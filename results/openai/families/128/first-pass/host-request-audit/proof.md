# A constructive verification of the host-request lemma

## Result and scope

Under exactly the hypotheses of `lem:host` in the staged September 24, 2026
manuscript, the host and all requesting layers can be rooted with added up-cost
at most the host budget plus the reserved requester budgets. The construction
works for arbitrarily many child groups and arbitrarily many requesters at each
record. Here, as in the manuscript, the collections are finite because they
come from a finite base edge multiset.

This is a universal mathematical verification of that local construction,
with kernel-checked component theorems and a separate exact word-level replay.
It is not a refutation, a proof of the complete approximation theorem, a claim
about maximum-overlap Greedy, or a claim of new approximation-ratio novelty.
The initial campaign ledger contained no earlier substantive host result to
improve. The improvement here is to replace the previously untested dependency
by an explicit construction whose coordinate, word-graph, and connectivity
components have independent executable checks. Independent Reviewer acceptance
and any publishability/novelty judgement remain outstanding.

The relevant source is
`research/openai_manuscript/A-Polynomial-Time-2-Approximation-for-Shortest-Common-Superstring-September-24-2026/build/`.
The original statement is `sections/04-connections.tex:63-132`; the graph is
defined in `02-counts.tex:3-5,84-90`, and the layer model in
`03-layers.tex:27-39,55-61`. No external theorem is needed below.

## Objects and hypotheses

Let \(V\) be the input substring language, including the empty word. It is
closed under substrings and contains each letter of the input alphabet.
The directed hierarchical edges append one last letter (cost one) or delete
one first letter (cost zero), with both words in \(V\).

A period-\(p\) layer has a text \(A:\mathbb Z\to\Sigma\) and an integer function
\(z\) satisfying
\[
z(x-1)\le z(x),\qquad z(x-1)\ge x,\qquad z(x+p)=z(x)+p.
\]
Its actual windows at start \(x\) have ends between \(z(x-1)\) and \(z(x)\).
All spell vertices of \(V\). The one-step monotonicity of \(z\) implies
monotonicity on all integers by iteration. A layer's underlying graph support
is connected: it is the image of its one-period closed walk.

The host has positive period \(q\). For each child group \(i\), its positive
period is \(p_i\), and its actual host record is \(R_i=[a_i,b_i)\).
Its text agrees with the host on that record in the specified alignment.
Child groups are pairwise different up to translation and different from the
host group. Each requesting layer at record \(i\) specifies an actual window
\([a_i,e)\) with
\[
a_i+p_i<e\le b_i-p_i. \tag{1}
\]
Each requester owns its reserved budget \(p_i\), and the host's budget \(q\)
is available. Budgets are per layer, not per graph vertex.

## 1. Agreement bounds, without an imported theorem

Suppose period-\(p\) text \(A\) and period-\(q\) text \(B\) agree on
\([a,a+p+q)\). For \(y\in[a,a+q)\), both \(y,y+p\) lie there, so
\(B(y+p)=A(y+p)=A(y)=B(y)\). Reduce any integer modulo \(q\) to obtain the
same identity everywhere. Thus \(B\) also has period \(p\). Reducing modulo
\(p\), agreement on \([a,a+p)\) now gives \(A=B\) everywhere.

Consequently, distinct aligned texts agree on fewer than \(p+q\) consecutive
positions. This is proved in Lean as `texts_equal_of_agreement` and
`agreement_bound`; it does not assume Fine--Wilf or primitive periods.
In particular,
\[
b_i-a_i<p_i+q. \tag{2}
\]
For records \(i\) before \(l\) on a lift of the host path,
\[
b_i-a_l<p_i+p_l. \tag{3}
\]
If their windows overlap, the overlap is a common interval of the two child
texts, and the bound just proved applies. If not, the left side is
nonpositive and both periods are positive.

## 2. Cyclic record order and the full alignment transport

If actual windows \([a,b)\), \([c,d)\) have \(a<c\), then
\[
b\le z(a)\le z(c-1)\le d.
\]
At an equal start their ends can be sorted. Thus lexicographic path order
also orders both coordinates.

Choose any child index \(j\) minimizing \(p_j\), and fix its record
\((a_j,b_j)\). Translate every other record by the unique multiple \(kq\)
putting its start in \([a_j,a_j+q)\). If that start equals \(a_j\) but its
end is below \(b_j\), translate once more by \(q\). The resulting actual
record lies componentwise between \(R_j\) and \(R_j+q\):
\[
a_j\le a_i\le T:=a_j+q,\qquad b_j\le b_i\le b_j+q. \tag{4}
\]
For the exceptional second translation its start is \(T\); its upper end
bound follows from the original end comparison, and its lower end bound
from the actual-window order. This handles vertical ties rather than
silently excluding them. Sort the finite resulting list lexicographically.

Crucially, a record shift \(\delta=kq\) is not presumed to be a child period.
Transport the entire child coordinate system by
\[
A_i'(x)=A_i(x-\delta),\qquad
z_i'(x)=z_i(x-\delta)+\delta,\qquad e'=e+\delta.
\]
The word of every transported child window is unchanged, as is its period,
actual-window property, and budget. Its graph vertex is therefore unchanged.
The host text is unchanged because \(\delta\) is a host-period multiple.
Distinctness up to translation is preserved under these separate transports.
These facts also apply to the next copy of \(j\).

The corresponding universal Lean results are `normalize_record`,
`normalized_pair_order`, `actual_translate`, `transport_word`,
`transport_actual`, `transport_layer`, `transport_periodic`,
`transport_distinct`, and `periodic_int`. In particular, normalization does
not require distinct starts or a fixed child alignment after shifting.

## 3. Clipped contacts and their order

At \(j\), visit every specified requester window in increasing order of its
end, then \(R_j\). Write \(e_0\) for the least of these ends.
For every other requester at \(i\), use
\[
s_i=\min(a_i+p_i,T),\qquad h_{i,e}=\max(e,b_j),\qquad
Q_{i,e}=[s_i,h_{i,e}). \tag{5}
\]
Both (4) and (1) show
\[
a_i\le s_i\le a_i+p_i<e\le h_{i,e}\le b_i.
\]
Thus the target is nonempty, is a substring of its actual host record, and
belongs to \(V\); it agrees with child \(i\)'s transported text.

For earlier \(i\) and later \(l\), (1) and (3) give, for every pair of
requesters,
\[
a_i+p_i<e_i\le b_i-p_i<a_l+p_l<e_l.
\]
Hence both raw starts and raw ends increase between groups. Within a group,
starts are equal and requester ends are sorted. Applying the same
nondecreasing functions \(\min(-,T)\) and \(\max(-,b_j)\) preserves order.
The initial \(j\)-windows, \(R_j\), and all clipped contacts therefore form
an ordered list.

Using (3) between \(i\) and the next copy of \(j\), and using (2) at \(j\),
\[
e\le b_i-p_i<T+p_j,\qquad b_j<T+p_j,\qquad h_{i,e}<T+p_j. \tag{6}
\]
The final window \([T,e_0+q)\) has end strictly greater than \(T+p_j\), since
\(e_0>a_j+p_j\). It follows every preceding target in both coordinates.

For the child loops we also need
\[
a_i\le s_i\le a_i+p_i,\qquad e\le h_{i,e}\le e+p_i. \tag{7}
\]
If \(h=e\) the upper bound is immediate. Otherwise (3) and minimality give
\[
b_j<a_i+p_j+p_i\le a_i+2p_i<e+p_i.
\]
This is exactly where selecting a minimum-period child is used.
Lean's `raw_separation`, `clipping_order`, `clipped_contact`, and
`attachment_order` check these inequalities for arbitrary integers.

## 4. Actual directed paths, not assumed contacts

For ordered valid windows \([a,b)\), \([c,d)\):

* If \(c\le b\), delete first letters until \([c,b)\), then append last
  letters until \([c,d)\). The deletion words are suffixes of the first word;
  the append words are prefixes of the second. The up-cost is \(d-b\).
* If \(c>b\), delete to the empty word, perform one-letter up/down cycles for
  the gap \([b,c)\), and build the second word. The up-cost is again \(d-b\).
  Each gap letter belongs to \(V\).

In either case a visited word has length at most \(\max(0,b-c)\).
Only prescribed windows, not the entire swept interval, need lie in \(V\).
These paths are constructed in `ordered_windows` from actual word lists.
The `Walk` constructors permit only the two directed edges specified above;
its natural-number index counts up edges, not total edges or distance in a
larger graph.

`WindowChain.realize` follows any finite ordered valid list, retains its
target vertices, and telescopes its cost to the end increase.
`WindowChain.closed` closes a periodic translate.
`close_at_short` also retains an actual short vertex on the final transition.
Applying these results to the list in Section 3 gives one host excursion of
cost exactly \(q\). Its final transition visits a word \(u\) of length
\[
|u|\le\max(0,h-T)<p_j.
\]
If there is no later record, replace \(h\) by \(b_j\); (2) gives the same
conclusion. This case is also checked by `only_group_short`.
The initial vertical portion touches every requester at \(j\), and \(R_j\)
touches the actual host layer.

For every requester with \(i\ne j\), follow, in its transported child text,
\[
Q_{i,e},\quad [a_i+p_i,e+p_i),\quad Q_{i,e}+p_i.
\]
Inequalities (7) order these three windows. The middle word equals the
specified actual requester word; the last equals the first. All three are
valid graph words, so the resulting loop costs exactly \(p_i\).
`attachment_loop` constructs this loop and proves membership of the actual
requester word in its support. Repeated words and multiple requesters cause
no exception: loops are added as edge multisets and are charged separately.

## 5. Rooting, balance, and the total budget

Delete the short word \(u\) to the empty word and build \(u\) back by prefixes.
This is a closed graph walk of cost \(|u|<p_j\), constructed by
`Walk.round_trip`. Spend one reserved budget of a requester at \(j\) on it;
at least one such requester exists. No \(j\)-requester needs an attachment
loop, because all were already touched by the host excursion.

The root round trip intersects the host excursion at \(u\). Every other
attachment loop intersects that excursion at its own \(Q_{i,e}\).
Therefore their union is connected to the empty word. This is not connectivity
in the unrestricted hierarchical graph: `rooted_star` uses precisely the
union of the constructed walks' edge supports. `attach_layer` adds the retained
base-layer edges at a touched vertex, thereby connecting every vertex of
each participating layer. `Walk.closed_balanced` proves zero signed
in/out flux at every vertex of a closed walk, so added multiplicities remain
balanced.

If \(n_j\ge1\) is the number of requesters at \(j\), the actual added cost is
\[
q+\sum_{i\ne j}\sum_{\text{requesters at }i}p_i+|u|
\ \le\
q+\sum_{i\ne j}\sum_{\text{requesters at }i}p_i+n_jp_j.
\]
`budget_bound` certifies the final natural-number inequality. All charged
budgets are available by the original hypotheses. No host or requester budget
is charged twice.

This proves `lem:host`. The proof even uses only positive periods, not their
minimality within each group; it does not remove the required distinctness of
the child groups or the original strict requester inequality.

## Exact replay and formal boundary

Run `python3 research/host-request-audit/verify.py --self-test` from the campaign
root. The certificate contains a primitive period-36 host, distinct primitive
child groups of periods 4, 5, and 7, and five actual requesting layers.
Record coordinates require transports \(0,108,-36\). The period-5 contacts
exercise end clipping and the period-7 contact exercises start clipping.
The verifier builds \(V\) from actual layer top windows, constructs every base
and added directed walk, checks each edge and multiplicity balance, and checks
underlying connectivity by graph traversal. Its cost is 55 against budget 61.
Eight independently altered witnesses are rejected.

The preserved Jacobian call `word.periods.compute` has the exact payload
`jacobian_payload.json` and typed result `jacobian_result.json`, server 0.14.0,
protocol 2025-11-25. For the finite word `abaaaba`, its overlap periods are
4, 6, 7 while it is a primitive length-7 block. The infinite repetition's
least period is therefore 7, not the finite word's overlap period 4.
The verifier independently replays these distinctions; Jacobian is not being
used as a proof of the universal construction.

The Lean certificate is for the universal components named in
`statement_fidelity.md`, attached mechanically to `H_PATHS`. There is no single
Lean declaration encoding all original host data and the entire finite
assembly as `lem:host`; the finite minimum selection, sorting, and substitution
of the component results are the mathematical proof above. Thus the whole host
claim receives a human judgement, not an inaccurately labelled kernel-closed
status. The count rule, layer-sorting theorem, processing partition, cycle
opening, and bit-polynomial implementation remain separate open dependencies.
