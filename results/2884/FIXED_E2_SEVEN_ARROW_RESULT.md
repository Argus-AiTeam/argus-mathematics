# Candidate seven-arrow diffeomorphism

## Result at Engineer handoff

The aggregate certificate constructs a candidate exact, unstabilized,
orientation-preserving diffeomorphism

\[
E(2)_{6_3}\longrightarrow E(2)_{19nh_{78}}
\]

with a two-sided inverse.  This is a candidate pending independent Reviewer
replay, not yet a campaign completion claim.

The certificate does not use either rejected symbolic artifact:

- `reviewed-v4-final-fixed-e2-composition/final_certificate.json`;
- `figure22-frozen-carrier-ambient-bridge/ambient_bridge_certificate.json`.

In particular, no attaching circle, push-off, sphere, or handle is transported
by a record of the form `Phi(name)`.

## Exact seven-arrow chain

| Arrow | Source | Target | Exact PL representative | Exact inverse |
|---|---|---|---|---|
| \(a_1\) | \(X_0=E(2)_{6_3}\) | \(X_1=Z_0(m_0)\) | reviewed two-port \(E(1)\)-cap endpoint identification | its endpoint inverse |
| \(a_2\) | \(X_1\) | \(X_2=Z_1(\beta_1)\) | reviewed relative trace transfer | inverse trace transfer |
| \(a_3\) | \(X_2\) | \(X_3=\) K0 post-cancellation terminal | reviewed K0 endpoint correspondence | inverse K0 endpoint correspondence |
| \(a_4\) | \(X_3\) | \(X_4=\) Figure-22 source common mother | \(P^{-1}\circ Q^{-1}\) | \(Q\circ P\) |
| \(a_5\) | \(X_4\) | \(X_5=\) source-bound K1 terminal | five source-bound moves and R--B cancellation | terminal-derived serialized inverse |
| \(a_6\) | \(X_5\) | \(X_6=Z_1(m_1)\) | exact source/native K1 endpoint action | the self-inverse endpoint action |
| \(a_7\) | \(X_6\) | \(X_7=E(2)_{19nh_{78}}\) | reviewed two-port \(E(1)\)-cap endpoint identification | its endpoint inverse |

Every adjacent target state is byte-for-byte the next arrow's source state.
For \(X_1,\ldots,X_6\), the serialized state is the movable marked core and
the top-level object means its closure by the two pinned \(E(1)-\nu F\)
caps.  The cap-extension theorem and reviewed native endpoint claim are part
of the arrow evidence.  Consequently \(a_1\) and \(a_7\) are diffeomorphisms
between closed presentations; they are not literal deletion maps from a
closed manifold to a manifold with boundary.

The exact state digests are:

| State | SHA-256 of canonical state |
|---|---|
| \(X_0\) | `4c366c17990b6083e9f07b4619df711ab0c9a5c2bd4be58c1253f8bef7a53899` |
| \(X_1\) | `16053cb516618a188e9a6d21925876681aed98792dac10de812841b8ad08a17e` |
| \(X_2\) | `797b6180d7839f06cb133021a2bd6fc7d2b2aee10063d8717bff97edf8e43c05` |
| \(X_3\) | `8d4278548b2ad2420274a961f595f67720ef78ec166772b713acd9ff8c7e60ac` |
| \(X_4\) | `a29d1e4a592bb7d3b2b45ecb01ebdcab43e46deaa5a1bedef1abb6d297781713` |
| \(X_5\) | `a8732f72a4e29b9bdb80db94e0ac104d2baf77c7691c23858345745566f9c80d` |
| \(X_6\) | `18a6f3b73db6b4de0ffdd94914b36c05ea77e21c098dcb6bde1ae1298274b12f` |
| \(X_7\) | `5b2b34b7385dd174f4da5b96b643b2574d0181f47140f56992624e9804e6551e` |

## The new fourth arrow

Let \(S=X_4\) be the complete Figure-22 source mother and let \(N\) be the
source-independent native \(1/28/5/2\) carrier.  The reviewed pointwise blocks
assemble to

\[
P:S\longrightarrow N.
\]

They comprise the H2-15 filled-cusp map, the 47-cell/74-face H2-28 inclusion,
the two complete cap maps, and the central \(T^2\times P\) map.  Together they
carry:

- the dotted one-handle;
- all 28 ordered two-handles and their fixed push-offs and framings;
- all five three-handle spheres;
- both four-handles;
- all 36 signed cocore disks;
- the complete cross-block overlap data.

The native pre-cancellation prefix is

\[
Q:N\longrightarrow X_3.
\]

Thus the fourth forward arrow and inverse are

\[
a_4=P^{-1}\circ Q^{-1},\qquad a_4^{-1}=Q\circ P.
\]

Their composites reduce literally:

\[
(Q\circ P)(P^{-1}\circ Q^{-1})=\mathrm{id}_{X_3},\qquad
(P^{-1}\circ Q^{-1})(Q\circ P)=\mathrm{id}_{X_4}.
\]

The Figure-22 source object and source-bound common mother have different
construction metadata, but their complete mathematical fields agree exactly.
The normalized common mathematical state digest is
`d7b2cc4150ba227ac5b1db3fb45212fb27ffb1df12d954d7a2f062791d60bca8`.

## Smooth category

The exact pointwise data above certifies PL representatives
\(a_1,\ldots,a_7\).  `SMOOTHING.md` supplies the separate smooth-category
argument.

Write \(\alpha_i\) for the fixed smooth handle atlas on \(X_i\), set

\[
\beta_7=\alpha_7,\qquad \beta_{i-1}=a_i^*(\beta_i),
\]

and use low-dimensional smoothing uniqueness to choose

\[
h_i:(X_i,\alpha_i)\longrightarrow(X_i,\beta_i)
\]

orientation-preserving and concordant to the identity, with
\(h_7=\mathrm{id}\).  The seven maps between the fixed smooth atlases are

\[
d_i=h_i^{-1}a_i h_{i-1},\qquad
d_i^{-1}=h_{i-1}^{-1}a_i^{-1}h_i.
\]

They are genuine orientation-preserving diffeomorphisms, and direct
cancellation proves both local inverse identities and both identities for the
global composite.  This uses Hirsch's concordance/product results and the
vanishing of the dimension-four smoothing-uniqueness obstructions described
by Milnor.

The marked claim is intentionally precise: the PL representatives carry every
serialized mark pointwise; the smooth arrows are concordant to those
representatives.  The existential smoothing-identification maps \(h_i\) are
not claimed to fix every marked PL cell pointwise.

## Endpoint and scope checks

- The knots are exactly \(6_3\) and \(19nh_{78}=A(6_3)\), and the current
  reviewed knot claim records that they are prime, distinct, and not mirrors.
- The ambient manifold is fixed \(E(2)\).
- The Fintushel--Stern gluing is the standard fixed gluing.
- Every arrow has orientation sign \(+1\).
- The stabilization count is zero.
- The endpoint peripheral matrix is
  \(\operatorname{diag}(1,-1)\); the global endpoint action is
  \(\operatorname{diag}(-1,1,-1)\), of determinant \(+1\), and is
  self-inverse.
- No originality statement is made.

The current version of `C-SOURCE-BOUND-K1-ENDPOINT-BRIDGE` is not presented as
reviewed.  Its immutable exact construction and endpoint comparison are
replayed as an internal subproof of this new candidate and must be judged in
the final independent review.

## Rerunnable certificate

Run:

```bash
/home/argustest/zimo/argus-latest/.venv/bin/python \
  research/fixed-e2-closed-kirby/final-seven-arrow-diffeomorphism/build_certificate.py
```

The replay hard-pins 31 source artifacts, reconstructs the eight states,
replays the five-move and endpoint inverses, checks all seven PL and smooth
arrow interfaces, checks the exact Jacobian 8-by-8 interface inverse, and
rejects 17 mutations.  The mutation suite includes handle and cocore
omission/duplication, cusp-role and peripheral-sign changes, overlap failure,
orientation reversal, symbolic-map substitution, smoothing failure, endpoint
knot and gluing changes, stabilization, local/global inverse failures, and
reversal of the typed fourth-arrow composition order, and loss of the fixed
two-cap closure convention.

Current immutable outputs:

- `aggregate_certificate.json`
  - SHA-256: `c7f8127799d3c702ec85f7b3ec105624a3131e1d6a19a87f00e957e2315d885d`
  - semantic digest:
    `2b0825340c78baf8da002c8148893aa92293f5102d674fea42801216d1313415`
- `checker_output.json`
  - SHA-256: `6051db47ece811004a76c32433c882dd44bdb3a442331ec6bb9fa984f67994b1`
  - status: `pass`
  - mutation rejections: `17/17`

The Jacobian record is an algebraic interface checksum only.  It used
`matrix.inverse.compute` on the exact direct-sum marked-interface matrix,
through Jacobian 0.14.0 and protocol `2025-11-25`, with no adapter error or
timeout; it is not substituted for the geometric bridge.
