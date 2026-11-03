#!/home/argustest/zimo/argus-latest/.venv/bin/python
"""Read-only exact certificate replay; does not import the construction code."""

from __future__ import annotations

import argparse
import json
import time
from pathlib import Path


HERE = Path(__file__).resolve().parent
LABELS = ("z", "q", "a", "l", "u", "e")
IMAGES = ((1, 2, 3, 4, 0), (1, 2, 0, 3, 4))
ID = tuple(range(5))
LITERALS = {
    "P0": ((-1, 2, 2, 1, -2, -2, -2), (-1, 2, 1, 1, -2, -1, -1)),
    "P2": ((-1, 2, 2, 1, -2, -2, -2), (-1, 2, 1, 1, 2, -1, -1)),
}


def need(condition, message):
    if not condition:
        raise AssertionError(message)


def reduced(letters):
    stack = []
    for x in letters:
        if stack and stack[-1] == -x:
            stack.pop()
        else:
            stack.append(x)
    return tuple(stack)


def inverse(word):
    return tuple(-x for x in reversed(word))


def conjugate(h, word):
    return reduced(h + word + inverse(h))


def compose(p, q):
    return tuple(p[q[i]] for i in range(5))


def pinverse(p):
    return tuple(p.index(i) for i in range(5))


def dependencies(nodes, root, factor=False):
    result, todo = set(), [root]
    while todo:
        index = todo.pop()
        if index in result:
            continue
        result.add(index)
        node = nodes[index]
        if node[0] == "mul":
            todo.extend(node[1:])
        elif node[0] == "inv":
            todo.append(node[1])
        elif factor and node[0] == "conj":
            todo.append(node[2])
    return sorted(result)


def universal_rules():
    """Free reduction on indeterminates certifies identities for every group."""
    a, b, c, d, h, e = ((i,) for i in range(1, 7))
    count = 0

    def law(name, left, right):
        nonlocal count
        need(reduced(left + inverse(right)) == (), f"invalid universal rule: {name}")
        count += 1

    law("product errors", (a + b) + (c + d) + inverse(b + d),
        a + conjugate(b, c))
    law("inverse errors", inverse(a + b) + b, conjugate(inverse(b), inverse(a)))
    law("conjugated errors", conjugate(h, a + b) + inverse(conjugate(h, b)),
        conjugate(h, a))
    law("telescoping anchor",
        a + inverse(b) + b + inverse(c) + c + inverse(d) + d + inverse(e) + e, a)
    law("anchor atom", (b + e) + inverse(b), conjugate(b, e))
    law("first correction", (a + c) + inverse(c) + d, a + d)
    law("second correction error",
        h + inverse(e) + d + inverse(h + d), conjugate(h, inverse(e)))

    u, chat, b, E2, J = a, c, d, h, e
    target_a = u + b
    ell, V = target_a + chat, b + chat
    B = E2 + V
    p = ell + inverse(B)
    E1 = conjugate(u, inverse(E2))
    W3 = inverse(J) + inverse(chat)
    final_b = B + W3
    Eb = E2 + conjugate(V, inverse(J))
    law("changed first donor", p + inverse(u), E1)
    law("changed donor atom error", u + inverse(p), inverse(E1))
    law("final second endpoint", final_b + inverse(b), Eb)
    law("final first endpoint", p + final_b + inverse(target_a),
        E1 + conjugate(u, Eb))

    for receiver in (0, 1):
        for sign in (1, -1):
            pair = [a, b]
            original = pair[:]
            donor = 1 - receiver
            if sign < 0:
                pair[donor] = inverse(pair[donor])
            pair[donor] = conjugate(h, pair[donor])
            pair[receiver] = reduced(pair[receiver] + pair[donor])
            pair[donor] = conjugate(inverse(h), pair[donor])
            if sign < 0:
                pair[donor] = inverse(pair[donor])
            expected = original[:]
            expected[receiver] = reduced(
                expected[receiver] + conjugate(
                    h, original[donor] if sign > 0 else inverse(original[donor])
                )
            )
            need(pair == expected, "strict signed donor expansion fails")
            count += 1
    return count


class Frozen:
    def __init__(self, certificate):
        self.certificate = certificate
        self.w = [tuple(node) for node in certificate["words"]]
        self.f = [tuple(node) for node in certificate["factors"]]
        self.wi = {node: i for i, node in enumerate(self.w)}
        self.fi = {node: i for i, node in enumerate(self.f)}
        need(len(self.wi) == len(self.w), "duplicate word nodes")
        need(len(self.fi) == len(self.f), "duplicate factor nodes")
        need(self.w[:3] == [("one",), ("letter", 1), ("letter", 2)], "wrong free basis")
        need(self.f[0] == ("one",), "missing factor identity")
        self.exp, self.length, self.count = [], [], []
        for i, node in enumerate(self.w):
            kind = node[0]
            if kind == "one":
                need(i == 0 and len(node) == 1, "extra word identity")
                exp, length = (0, 0), 0
            elif kind == "letter":
                need(node in (("letter", 1), ("letter", 2)), "extra free generator")
                exp, length = ((1, 0) if node[1] == 1 else (0, 1)), 1
            elif kind in ("mul", "inv"):
                need(len(node) == (3 if kind == "mul" else 2), "bad word arity")
                need(all(type(x) is int and 0 <= x < i for x in node[1:]),
                     "cyclic or invalid word reference")
                if kind == "mul":
                    exp = tuple(x + y for x, y in zip(self.exp[node[1]], self.exp[node[2]]))
                    length = self.length[node[1]] + self.length[node[2]]
                else:
                    exp = tuple(-x for x in self.exp[node[1]])
                    length = self.length[node[1]]
            else:
                raise AssertionError(f"unsupported word constructor {kind}")
            self.exp.append(exp)
            self.length.append(length)
        for i, node in enumerate(self.f):
            kind = node[0]
            counts = [0] * (2 * len(LABELS))
            if kind == "one":
                need(i == 0 and len(node) == 1, "extra factor identity")
            elif kind == "atom":
                need(len(node) == 2 and node[1] in LABELS, "unknown donor")
                counts[2 * LABELS.index(node[1])] = 1
            else:
                arity = 2 if kind == "inv" else 3
                need(kind in ("mul", "inv", "conj") and len(node) == arity,
                     "invalid factor constructor")
                refs = node[2:] if kind == "conj" else node[1:]
                need(all(type(x) is int and 0 <= x < i for x in refs),
                     "cyclic or invalid factor reference")
                if kind == "conj":
                    need(type(node[1]) is int and 0 <= node[1] < len(self.w),
                         "invalid frozen conjugator")
                    counts = self.count[node[2]]
                elif kind == "mul":
                    counts = [x + y for x, y in zip(self.count[node[1]], self.count[node[2]])]
                else:
                    counts = [self.count[node[1]][j ^ 1] for j in range(len(counts))]
            self.count.append(tuple(counts))
        self.sub_cache, self.value_cache = {}, {}
        self.free_cache, self.perm_cache, self.flow_cache = {}, {}, {}

    def mul(self, x, y):
        return (x or y) if not x or not y else self.wi[("mul", x, y)]

    def inv(self, x):
        if not x:
            return 0
        return self.w[x][1] if self.w[x][0] == "inv" else self.wi[("inv", x)]

    def product(self, values):
        result = 0
        for value in values:
            result = self.mul(result, value)
        return result

    def power(self, x, n):
        if n < 0:
            x, n = self.inv(x), -n
        result = 0
        while n:
            if n & 1:
                result = self.mul(result, x)
            n //= 2
            if n:
                x = self.mul(x, x)
        return result

    def conj(self, h, x):
        return self.product((h, x, self.inv(h)))

    def comm(self, x, y):
        return self.product((x, y, self.inv(x), self.inv(y)))

    def letters(self, letters):
        return self.product(x if x > 0 else self.inv(-x) for x in reduced(letters))

    def fm(self, x, y):
        return (x or y) if not x or not y else self.fi[("mul", x, y)]

    def fp(self, values):
        result = 0
        for value in values:
            result = self.fm(result, value)
        return result

    def fi_inv(self, x):
        if not x:
            return 0
        return self.f[x][1] if self.f[x][0] == "inv" else self.fi[("inv", x)]

    def fc(self, h, x):
        return x if not h or not x else self.fi[("conj", h, x)]

    def atom(self, label):
        return self.fi[("atom", label)]

    def substitute(self, root, images):
        key = root, tuple(images)
        if key in self.sub_cache:
            return self.sub_cache[key]
        values = {}
        for index in dependencies(self.w, root):
            node = self.w[index]
            if node[0] == "one":
                value = 0
            elif node[0] == "letter":
                value = images[node[1] - 1]
            elif node[0] == "mul":
                value = self.mul(values[node[1]], values[node[2]])
            else:
                value = self.inv(values[node[1]])
            values[index] = value
        self.sub_cache[key] = values[root]
        return values[root]

    def value(self, root, atoms):
        axis = tuple(sorted(atoms.items()))
        for index in dependencies(self.f, root, factor=True):
            key = index, axis
            if key in self.value_cache:
                continue
            node = self.f[index]
            get = lambda i: self.value_cache[(i, axis)]
            if node[0] == "one":
                value = 0
            elif node[0] == "atom":
                value = atoms[node[1]]
            elif node[0] == "mul":
                value = self.mul(get(node[1]), get(node[2]))
            elif node[0] == "inv":
                value = self.inv(get(node[1]))
            else:
                value = self.conj(node[1], get(node[2]))
            self.value_cache[key] = value
        return self.value_cache[(root, axis)]

    def transform(self, root, replacements, images):
        values = {}
        for index in dependencies(self.f, root, factor=True):
            node = self.f[index]
            if node[0] == "one":
                value = 0
            elif node[0] == "atom":
                value = replacements.get(node[1], index)
            elif node[0] == "mul":
                value = self.fm(values[node[1]], values[node[2]])
            elif node[0] == "inv":
                value = self.fi_inv(values[node[1]])
            else:
                by = node[1] if images is None else self.substitute(node[1], images)
                value = self.fc(by, values[node[2]])
            values[index] = value
        return values[root]

    def difference(self, root, images, generators):
        pairs = {}
        for index in dependencies(self.w, root):
            node = self.w[index]
            if node[0] == "one":
                pair = (0, 0)
            elif node[0] == "letter":
                pair = (images[node[1] - 1], generators[node[1] - 1])
            elif node[0] == "mul":
                x, dx = pairs[node[1]]
                y, dy = pairs[node[2]]
                pair = self.mul(x, y), self.fm(dx, self.fc(x, dy))
            else:
                x, dx = pairs[node[1]]
                pair = self.inv(x), self.fc(self.inv(x), self.fi_inv(dx))
            pairs[index] = pair
        return list(pairs[root])

    def cyclic(self, root, diagonal):
        values = {}
        for index in dependencies(self.w, root):
            node = self.w[index]
            if node[0] == "one":
                pair = (0, 0)
            elif node[0] == "letter":
                pair = (
                    int(diagonal or node[1] == 2),
                    self.atom("u" if diagonal else "a") if node[1] == 1 else 0,
                )
            elif node[0] == "mul":
                i, x = values[node[1]]
                j, y = values[node[2]]
                pair = i + j, self.fm(x, self.fc(self.power(2, i), y))
            else:
                i, x = values[node[1]]
                pair = -i, self.fc(self.power(2, -i), self.fi_inv(x))
            values[index] = pair
        exponent, factor = values[root]
        need(exponent == 0, "nonzero cyclic remainder")
        return factor

    def defect(self, root, label, old_atom, new_atom, atom_error):
        values = {}
        for index in dependencies(self.f, root, factor=True):
            node = self.f[index]
            if node[0] == "one":
                value = (0, 0, 0)
            elif node[0] == "atom":
                need(node[1] == label, "wrong error-transport donor")
                value = old_atom, new_atom, atom_error
            elif node[0] == "mul":
                x, y, dx = values[node[1]]
                z, t, dz = values[node[2]]
                value = self.mul(x, z), self.mul(y, t), self.fm(dx, self.fc(y, dz))
            elif node[0] == "inv":
                x, y, dx = values[node[1]]
                value = self.inv(x), self.inv(y), self.fc(self.inv(y), self.fi_inv(dx))
            else:
                x, y, dx = values[node[2]]
                value = self.conj(node[1], x), self.conj(node[1], y), self.fc(node[1], dx)
            values[index] = value
        return list(values[root])

    def check_trace(self):
        for number, record in enumerate(self.certificate["trace"]):
            kind, *args = record
            if kind == "substitute":
                actual = self.substitute(*args[:-1])
            elif kind == "factor_value":
                actual = self.value(*args[:-1])
            elif kind == "factor_transform":
                actual = self.transform(*args[:-1])
            elif kind == "difference":
                actual = self.difference(*args[:-1])
            elif kind == "cyclic":
                actual = self.cyclic(*args[:-1])
            elif kind == "defect":
                actual = self.defect(*args[:-1])
            else:
                raise AssertionError(f"unsupported proof rule: {kind}")
            need(actual == args[-1], f"bad exact recurrence at record {number}: {kind}")

    def free_word(self, root):
        for index in dependencies(self.w, root):
            if index in self.free_cache:
                continue
            node = self.w[index]
            if node[0] == "one":
                value = ()
            elif node[0] == "letter":
                value = (node[1],)
            elif node[0] == "mul":
                value = reduced(self.free_cache[node[1]] + self.free_cache[node[2]])
            else:
                value = inverse(self.free_cache[node[1]])
            self.free_cache[index] = value
        return self.free_cache[root]

    def free_factor(self, root, atoms):
        values = {}
        for index in dependencies(self.f, root, factor=True):
            node = self.f[index]
            if node[0] == "one":
                value = ()
            elif node[0] == "atom":
                value = atoms[node[1]]
            elif node[0] == "mul":
                value = reduced(values[node[1]] + values[node[2]])
            elif node[0] == "inv":
                value = inverse(values[node[1]])
            else:
                value = conjugate(self.free_word(node[1]), values[node[2]])
            values[index] = value
        return values[root]

    def permutation(self, root):
        for index in dependencies(self.w, root):
            if index in self.perm_cache:
                continue
            node = self.w[index]
            if node[0] == "one":
                p = ID
            elif node[0] == "letter":
                p = IMAGES[node[1] - 1]
            elif node[0] == "mul":
                p = compose(self.perm_cache[node[1]], self.perm_cache[node[2]])
            else:
                p = pinverse(self.perm_cache[node[1]])
            self.perm_cache[index] = p
        return self.perm_cache[root]

    def first_order(self, root):
        for index in dependencies(self.w, root):
            if index in self.flow_cache:
                continue
            node = self.w[index]
            if node[0] == "one":
                state = ID, {}
            elif node[0] == "letter":
                state = IMAGES[node[1] - 1], {(ID, node[1]): 1}
            elif node[0] == "inv":
                g, chain = self.flow_cache[node[1]]
                gi = pinverse(g)
                state = gi, {(compose(gi, vertex), axis): -n
                             for (vertex, axis), n in chain.items()}
            else:
                g, first = self.flow_cache[node[1]]
                h, second = self.flow_cache[node[2]]
                chain = dict(first)
                for (vertex, axis), n in second.items():
                    key = compose(g, vertex), axis
                    chain[key] = chain.get(key, 0) + n
                    if not chain[key]:
                        del chain[key]
                state = compose(g, h), chain
            self.flow_cache[index] = state
        return self.flow_cache[root]

    def only(self, root, label):
        slot = 2 * LABELS.index(label)
        counts = self.count[root]
        need(all(x == 0 for i, x in enumerate(counts) if i not in (slot, slot + 1)),
             f"unexpected donor, expected only {label}")
        return counts[slot], counts[slot + 1]


def bind_source(t, name):
    certificate, r = t.certificate, t.certificate["roots"]
    source = HERE.parent / "ms14-rank-two-normal-kernel-lifting" / f"strict-{name}-k01.json"
    seed = json.loads(source.read_text())
    need(certificate["source"] == f"../ms14-rank-two-normal-kernel-lifting/{source.name}",
         "wrong reviewed seed path")
    need(seed["literal_relators"] == certificate["literal_relators"], "seed literal drift")
    need(seed["a_image"] == list(IMAGES[0]) and seed["b_image"] == list(IMAGES[1]),
         "seed kernel drift")
    wm, fm = [], []
    for node in seed["words"]:
        if node[0] == "one":
            value = 0
        elif node[0] == "letter":
            value = t.letters((node[1],))
        elif node[0] == "mul":
            value = t.mul(wm[node[1]], wm[node[2]])
        elif node[0] == "inv":
            value = t.inv(wm[node[1]])
        else:
            need(node[0] == "pow", "bad source word constructor")
            value = t.power(wm[node[1]], node[2])
        wm.append(value)
    for node in seed["normal_factors"]:
        if node[0] == "one":
            value = 0
        elif node[0] == "atom":
            value = t.atom(node[1])
        elif node[0] == "mul":
            value = t.fm(fm[node[1]], fm[node[2]])
        elif node[0] == "inv":
            value = t.fi_inv(fm[node[1]])
        else:
            need(node[0] == "conj", "bad source factor constructor")
            value = t.fc(wm[node[1]], fm[node[2]])
        fm.append(value)
    need(r["prefix_endpoint"] == [wm[x] for x in seed["endpoint_word_ids"]],
         "wrong first-order endpoints")
    need([r["c"], r["d"]] == [wm[x] for x in seed["residual_word_ids"]],
         "wrong free residual words")
    need(r["base_c_inverse_z"] == fm[seed["free_c_inverse_z_factor_root"]],
         "wrong free commutator factorization")
    need(r["base_d_inverse_a"] == fm[seed["phase_two_a_factor_root"]],
         "wrong free cyclic factorization")
    expected_prefix = []
    for record in seed["prefix_program"]:
        move = dict(record)
        if "right_conjugator_word" in move:
            move["right_conjugator_word"] = wm[move["right_conjugator_word"]]
        expected_prefix.append(move)
    need(certificate["prefix_program"] == expected_prefix, "changed prefix move")
    pair, count = [t.letters(x) for x in LITERALS[name]], 0
    for move in expected_prefix:
        kind = move["kind"]
        if kind in ("invert_first", "invert_second"):
            slot = 0 if kind.endswith("first") else 1
            pair[slot] = t.inv(pair[slot])
            count += 1
        elif kind in ("conjugate_first", "conjugate_second"):
            slot = 0 if kind.endswith("first") else 1
            pair[slot] = t.conj(t.inv(move["right_conjugator_word"]), pair[slot])
            count += 1
        else:
            need(kind in ("first_times_second", "second_times_first",
                          "first_times_second_inverse", "second_times_first_inverse"),
                 "non-AC prefix operation")
            slot = 0 if kind.startswith("first_") else 1
            negative = kind.endswith("_inverse")
            donor = t.inv(pair[1 - slot]) if negative else pair[1 - slot]
            pair[slot] = t.mul(pair[slot], donor)
            count += 3 if negative else 1
    need(pair == r["prefix_endpoint"], "actual literal word prefix does not match")
    need(r["c"] == t.mul(t.inv(1), pair[0]), "bad first residual definition")
    need(r["d"] == t.mul(t.inv(2), pair[1]), "bad second residual definition")
    for root in (r["c"], r["d"]):
        need(t.exp[root] == (0, 0), "residual is not in F'")
        need(t.first_order(root) == (ID, {}), "residual is not in the actual K'")
    need(t.free_factor(r["base_c_inverse_z"], {"z": (1, 2, -1, -2)})
         == inverse(t.free_word(r["c"])), "complete free C^-1 factor identity fails")
    need(t.free_factor(r["base_d_inverse_a"], {"a": (1,)})
         == inverse(t.free_word(r["d"])), "complete free d^-1 factor identity fails")
    return count


def main_derivation(t, prefix_count):
    r, c = t.certificate["roots"], t.certificate
    a, b, q = 1, 2, r["prefix_endpoint"][1]
    cinv, dinv = t.inv(r["c"]), t.inv(r["d"])
    chat, ell, u = r["chat"], r["ell"], r["u"]
    need(chat == t.substitute(r["c"], [a, dinv]), "bad changed donor word")
    need(ell == t.mul(a, chat) and u == t.mul(a, t.inv(b)), "wrong path anchors")
    need(t.permutation(ell) == IMAGES[0], "new donor lost the required A5 image")
    need(t.difference(cinv, [a, dinv], [0, t.atom("q")])
         == [t.inv(chat), r["phase1"]], "first correction is not certified")
    need(r["phi_words"][0] == a and len(r["phi_words"]) == 4, "wrong iteration count")
    need(len(r["phi_differences"]) == 3, "missing endomorphism difference")
    for i in range(3):
        need(t.difference(r["phi_words"][i], [t.inv(chat), b], [t.atom("l"), 0])
             == [r["phi_words"][i + 1], r["phi_differences"][i]],
             "wrong endomorphism iteration")
    need(len(c["finite_donor_products"]) == 2, "missing finite donor product")
    for slot, products in enumerate(c["finite_donor_products"]):
        factors, image = [], ID
        for letters, sign in products:
            need(sign in (1, -1), "non-strict donor factor")
            h_word = t.letters(letters)
            h = t.permutation(h_word)
            donor = IMAGES[0] if sign > 0 else pinverse(IMAGES[0])
            image = compose(image, compose(compose(h, donor), pinverse(h)))
            atom = t.atom("l") if sign > 0 else t.fi_inv(t.atom("l"))
            factors.append(t.fc(h_word, atom))
        need(image == IMAGES[slot], "finite donor identity fails")
        need(r["t_factors"][slot] == t.fp(factors), "wrong lifted finite donor product")
        need(r["t_words"][slot] == t.value(r["t_factors"][slot], {"l": ell}),
             "wrong finite product word")
        need(r["rho"][slot] == t.mul(t.inv(r["t_words"][slot]), slot + 1),
             "wrong homomorphism into K")
        need(t.permutation(r["rho"][slot]) == ID, "rho generator is not in K")
    need(t.difference(r["phi_words"][3], r["rho"], r["t_factors"])
         == [r["e"], r["rho_difference"]], "wrong final substitution residual")
    need(r["anchor"] == t.fp(r["phi_differences"] + [r["rho_difference"]]),
         "anchor does not telescope")
    need(r["anchor_word"] == t.value(r["anchor"], {"l": ell}), "wrong anchor value")
    t.only(r["anchor"], "l")

    layers = c["membership_layers"]
    need(len(layers) == 3, "certificate does not reach K^(3)")
    aj = r["rho"][0]
    for level, layer in enumerate(layers, 1):
        images = [aj, r["rho"][1]]
        need(layer["level"] == level and layer["images"] == images,
             "derived layer has wrong inputs")
        dj = t.substitute(dinv, images)
        need(layer["d_word"] == dj, "wrong derived-layer second commutator entry")
        need(layer["d_factor_root"] == t.transform(r["base_d_inverse_a"], {}, images),
             "missing homomorphic d^-1 normal-factor identity")
        t.only(layer["d_factor_root"], "a")
        need(layer["d_factor_value"] == t.value(layer["d_factor_root"], {"a": aj}),
             "wrong d membership witness")
        need(layer["c_factor_root"] == t.transform(r["base_c_inverse_z"], {}, [aj, dj]),
             "missing homomorphic C^-1 commutator identity")
        t.only(layer["c_factor_root"], "z")
        commutator = t.comm(aj, dj)
        need(layer["commutator_word"] == commutator, "not an actual commutator")
        need(layer["c_factor_value"] == t.value(layer["c_factor_root"], {"z": commutator}),
             "wrong commutator product value")
        next_a = t.substitute(t.inv(chat), images)
        need(next_a == t.substitute(cinv, [aj, dj]), "wrong composed homomorphism")
        need(layer["next_a"] == next_a, "membership layer certifies a different word")
        aj = next_a
    need(aj == r["e"], "membership proof does not reach the actual residual")

    need(r["m2"] == t.mul(dinv, chat), "wrong middle multiplier")
    need(r["m2_a"] == t.cyclic(r["m2"], False), "uncertified middle normal collection")
    need(r["phase2"] == t.transform(r["m2_a"], {"a": r["anchor"]}, None),
         "wrong middle donor replacement")
    need(r["W2"] == t.value(r["phase2"], {"l": ell}), "wrong middle strict multiplier")
    delta = t.defect(
        r["m2_a"], "a", a, r["anchor_word"], t.fc(r["anchor_word"], t.atom("e"))
    )
    need(delta[1:] == [r["W2"], r["m2_error"]], "middle error is not certified")
    need(r["B"] == t.mul(q, r["W2"]) and r["V"] == t.mul(b, chat), "bad middle endpoint")
    need(r["E2"] == t.fc(q, t.fi_inv(r["m2_error"])), "bad second-coordinate error")
    need(r["p"] == t.mul(ell, t.inv(r["B"])), "wrong actual changed donor")
    need(r["E1"] == t.fc(u, t.fi_inv(r["E2"])), "bad changed-donor error")
    need(r["phase3"] == t.cyclic(t.inv(chat), True), "uncertified diagonal collection")
    need(r["W3"] == t.value(r["phase3"], {"u": r["p"]}),
         "third correction does not use the actual current donor")
    delta = t.defect(r["phase3"], "u", u, r["p"], t.fi_inv(r["E1"]))
    need(delta[1:] == [r["W3"], r["J"]], "changed-donor transport is not certified")
    final_b = t.mul(r["B"], r["W3"])
    need(r["final_words"] == [t.mul(r["p"], final_b), final_b], "wrong literal endpoints")
    Eb = t.fm(r["E2"], t.fc(r["V"], t.fi_inv(r["J"])))
    Ea = t.fm(r["E1"], t.fc(u, Eb))
    need(r["endpoint_errors"] == [Ea, Eb], "wrong final exact error identities")
    need(r["endpoint_error_words"] == [t.value(x, {"e": r["e"]}) for x in (Ea, Eb)],
         "wrong endpoint error word values")
    for error in (Ea, Eb):
        t.only(error, "e")
    counts = {"prefix": prefix_count, "two_nielsen_moves": 4}
    for phase, label in (("phase1", "q"), ("phase2", "l"), ("phase3", "u")):
        positive, negative = t.only(r[phase], label)
        counts[phase] = 3 * positive + 5 * negative
    counts["total"] = sum(counts.values())
    need(counts == c["strict_move_counts"], "incorrect finite strict expansion count")
    need(c["endpoint_unreduced_lengths"] == [t.length[x] for x in r["final_words"]],
         "wrong endpoint length")
    need(c["residual_unreduced_length"] == t.length[r["e"]], "wrong residual length")


def replay(name):
    started = time.monotonic()
    certificate = json.loads((HERE / f"strict-{name}-k01.json").read_text())
    need(certificate["format"] == "relative-derived-strict-ac-v1", "unknown format")
    need(certificate["presentation"] == name and certificate["kernel_representative"] == 1,
         "wrong literal case")
    need(certificate["derived_length"] == 3, "wrong quotient")
    need(certificate["literal_relators"] == [list(x) for x in LITERALS[name]], "literal mismatch")
    need(certificate["a_image"] == list(IMAGES[0]) and certificate["b_image"] == list(IMAGES[1]),
         "wrong A5 action")
    table = Frozen(certificate)
    prefix_count = bind_source(table, name)
    table.check_trace()
    main_derivation(table, prefix_count)
    return {
        "presentation": name, "kernel": 1, "quotient": "F/K^(3)",
        "literal_source_binding": True,
        "complete_free_base_factor_identities": True,
        "full_integral_first_order_residuals_zero": True,
        "all_recorded_straight_line_recurrences": len(certificate["trace"]),
        "derived_membership_layers": 3,
        "residual_in_K_third_derived": True,
        "both_actual_donor_updates_certified": True,
        "both_exact_endpoint_errors_in_normal_closure_of_residual": True,
        "strict_moves": certificate["strict_move_counts"]["total"],
        "primitive_moves_individually_executed": False,
        "word_nodes": len(table.w), "factor_nodes": len(table.f),
        "elapsed_seconds": round(time.monotonic() - started, 3),
        "result": "exact_relative_nonseparation_certificate_replayed",
        "counterexample_found": False,
        "independent_reviewer_acceptance": "pending",
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--presentation", choices=("P0", "P2"))
    args = parser.parse_args()
    rules = universal_rules()
    print(json.dumps({"universal_free_group_identities": rules}), flush=True)
    for name in (args.presentation,) if args.presentation else ("P0", "P2"):
        print(json.dumps(replay(name), sort_keys=True), flush=True)


if __name__ == "__main__":
    main()
