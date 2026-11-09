#include <array>
#include <chrono>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <map>
#include <stdexcept>
#include <string>
#include <utility>
#include <vector>

struct Search {
    struct CoefficientCase {
        std::array<std::array<unsigned, 4>, 4> matrix;
        std::uint64_t count = 0;
    };

    int n, k;
    bool collect_coefficients;
    std::array<std::array<unsigned, 4>, 4> labels{};
    std::array<std::array<unsigned, 4>, 4> best_labels{};
    std::vector<std::pair<int, int>> pairs;
    std::vector<std::pair<unsigned, unsigned>> options;
    std::map<std::array<int, 16>, CoefficientCase> coefficient_cases;
    std::uint64_t visited = 0, missing_multiple = 0, cyclic = 0, acyclic = 0;
    int best = -100;
    bool found = false;

    Search(int vertices, int colours, bool collect = false)
        : n(vertices), k(colours), collect_coefficients(collect) {
        for (int u = 0; u < n; ++u)
            for (int v = u + 1; v < n; ++v)
                pairs.emplace_back(u, v);
        const unsigned end = 1U << k;
        for (unsigned a = 0; a < end; ++a)
            for (unsigned b = 0; b < end; ++b)
                if (a == 0 || b == 0 || (a == b && __builtin_popcount(a) == 1))
                    options.emplace_back(a, b);
    }

    void evaluate() {
        ++visited;
        std::array<std::array<unsigned, 3>, 4> outgoing{};
        std::array<int, 4> degree{};
        for (int u = 0; u < n; ++u) {
            bool multiple = false;
            for (int v = 0; v < n; ++v) {
                unsigned mask = labels[u][v];
                multiple |= __builtin_popcount(mask) >= 2;
                degree[u] += __builtin_popcount(mask);
                for (int c = 0; c < k; ++c)
                    if (mask & (1U << c))
                        outgoing[u][c] |= 1U << v;
            }
            // If every outgoing edge is singly labelled then D(u) <= |R(u)|.
            if (!multiple) {
                ++missing_multiple;
                return;
            }
        }
        int minimum = 100;
        std::array<unsigned, 4> endpoint_sets{};
        for (int start = 0; start < n; ++start) {
            std::array<unsigned, 8> reached{};
            reached[0] = 1U << start;
            unsigned endpoints = 0;
            for (unsigned mask = 0; mask < (1U << k); ++mask) {
                if (mask) {
                    if (reached[mask] & (1U << start)) {
                        ++cyclic;
                        return;
                    }
                    endpoints |= reached[mask];
                }
                for (int u = 0; u < n; ++u)
                    if (reached[mask] & (1U << u))
                        for (int c = 0; c < k; ++c)
                            if (!(mask & (1U << c)))
                                reached[mask | (1U << c)] |= outgoing[u][c];
            }
            endpoint_sets[start] = endpoints;
            minimum = std::min(minimum, degree[start] - __builtin_popcount(endpoints));
        }
        ++acyclic;
        if (collect_coefficients) {
            std::array<int, 16> coefficients{};
            for (int u = 0; u < n; ++u)
                for (int v = 0; v < n; ++v)
                    coefficients[4 * u + v] = __builtin_popcount(labels[u][v])
                        - static_cast<int>((endpoint_sets[u] >> v) & 1U);
            auto [entry, inserted] = coefficient_cases.try_emplace(
                coefficients, CoefficientCase{labels, 0});
            ++entry->second.count;
        }
        if (minimum > best) {
            best = minimum;
            best_labels = labels;
        }
        found = minimum >= 1;
    }

    void enumerate(std::size_t index) {
        if (found) return;
        if (index == pairs.size()) {
            evaluate();
            return;
        }
        auto [u, v] = pairs[index];
        for (auto [a, b] : options) {
            labels[u][v] = a;
            labels[v][u] = b;
            enumerate(index + 1);
            if (found) return;
        }
    }

    void output(double seconds) {
        std::uint64_t expected = 1;
        for (std::size_t i = 0; i < pairs.size(); ++i) expected *= options.size();
        if (!found && (visited != expected || visited != missing_multiple + cyclic + acyclic))
            throw std::runtime_error("Enumeration accounting mismatch");
        std::cout << "{\"n\":" << n << ",\"k\":" << k
                  << ",\"status\":\"" << (found ? "FOUND" : "EXHAUSTED") << "\""
                  << ",\"all_label_incidence_patterns\":" << (1ULL << (k * n * (n - 1)))
                  << ",\"pair_options\":" << options.size()
                  << ",\"digon_free_patterns\":" << expected
                  << ",\"visited\":" << visited
                  << ",\"excluded_without_outgoing_multilabel\":" << missing_multiple
                  << ",\"excluded_rainbow_cycle\":" << cyclic
                  << ",\"cycle_free_tested\":" << acyclic
                  << ",\"seconds\":" << seconds
                  << ",\"best_minimum_deficit\":";
        if (best == -100) std::cout << "null";
        else std::cout << best;
        std::cout << ",\"best_matrix\":";
        if (best == -100) std::cout << "null";
        else {
            std::cout << "[";
            for (int u = 0; u < n; ++u) {
                if (u) std::cout << ",";
                std::cout << "[";
                for (int v = 0; v < n; ++v) {
                    if (v) std::cout << ",";
                    std::cout << best_labels[u][v];
                }
                std::cout << "]";
            }
            std::cout << "]";
        }
        std::cout << "}\n";
    }

    void write_coefficients(const std::string& path) {
        std::ofstream stream(path);
        if (!stream) throw std::runtime_error("Cannot write coefficient cases");
        stream << "{\"n\":" << n << ",\"k\":" << k << ",\"cases\":[";
        bool first = true;
        for (const auto& [coefficients, entry] : coefficient_cases) {
            if (!first) stream << ",";
            first = false;
            stream << "{\"template_count\":" << entry.count << ",\"A\":[";
            for (int u = 0; u < n; ++u) {
                if (u) stream << ",";
                stream << "[";
                for (int v = 0; v < n; ++v) {
                    if (v) stream << ",";
                    stream << coefficients[4 * u + v];
                }
                stream << "]";
            }
            stream << "],\"representative_matrix\":[";
            for (int u = 0; u < n; ++u) {
                if (u) stream << ",";
                stream << "[";
                for (int v = 0; v < n; ++v) {
                    if (v) stream << ",";
                    stream << entry.matrix[u][v];
                }
                stream << "]";
            }
            stream << "]}";
        }
        stream << "]}\n";
        if (!stream) throw std::runtime_error("Incomplete coefficient output");
    }
};

int main(int argc, char** argv) {
    if (argc != 3 && argc != 4)
        throw std::invalid_argument("Usage: enumerate_rainbow n k [coefficient-output.json]");
    const int n = std::stoi(argv[1]), k = std::stoi(argv[2]);
    if (n < 1 || n > 4 || k < 1 || k > 3)
        throw std::invalid_argument("This exhaustive engine supports only 1<=n<=4, 1<=k<=3");
    auto begin = std::chrono::steady_clock::now();
    Search search(n, k, argc == 4);
    search.enumerate(0);
    search.output(std::chrono::duration<double>(std::chrono::steady_clock::now() - begin).count());
    if (argc == 4) search.write_coefficients(argv[3]);
}
