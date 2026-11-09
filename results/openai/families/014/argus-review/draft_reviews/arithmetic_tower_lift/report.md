# Arithmetic-tower lift

**Assessment: partial support; the stated arithmetic conclusion is
unresolved.** This is `L_ABG_LIFT@1`, old `theorem.md` Section 3, with
the component argument in Section 6. The assessment agrees with the old
independent receipt `judgement-L_ABG_LIFT-b995c518f964` (`inconclusive`),
not the earlier author support `...-4b5e59b0c2f2`.

## Exact claim and hypotheses

For \(k_0=\mathbb F_q\), \(\ell\ne\operatorname{char}k_0\),
\(L/\mathbb Q_\ell\) finite, a smooth projective geometrically connected
pointed curve \((X_0,\Delta_0)/k_0\), and a continuous arithmetic
\(\mathrm{PGL}_n(L)\)-parameter on \(U_0=X_0-\Delta_0\) killing wild
inertia and having unipotent tame boundary, the draft claims a lift over
\(D=\operatorname{Frac}W(k_0)\). On
\((C_1-\Delta_1)_{\bar D}\) it should recover the **entire prescribed
arithmetic finite right-torsor tower**, its boundary frames and transports,
and exactly the original geometric compact image. In the combined
application that geometric image is Zariski dense. No regularity is assumed.

## What is supported

The unobstructed pointed-curve deformation argument uses the vanishing of
the two indicated \(H^2\)'s; the draft then lifts an ample bundle and
algebraizes. At finite torsor level, the unipotent boundary factors through
the pro-\(\ell\) tame quotient. Thus one may choose divisible
\(\ell\)-power root indices killing the finitely many inertia images.
The order of the entire finite quotient \(\Gamma_r\) need **not** be prime
to the residue characteristic.

The inherited source `A_LO_ROOTS` is Lieblich--Olsson,
*Generators and relations for the etale fundamental group*, final PAMQ
6(1) (2010), Appendix A.2, Proposition A.10 and Theorem A.11,
`doi:10.4310/PAMQ.2010.v6.n1.a6`. Its proper smooth pair setup and
invertible root orders support the tame root extension, after the stated
strict henselian base change and descent by unique normalization.
Generic restriction on **all** finite etale covers is fully faithful,
not the equivalence asserted only for the restricted prime-to-characteristic
subcategory. The draft correctly avoids using an equivalence on all generic
tame covers.

`A_RYDH_PROPER`, Rydh's dated 2014-09-16 author preprint, Theorem 4.5,
pp.11-12, applies to a proper stack with finite diagonal over a henselian
local ring. It lifts the finite covers on the proper root stacks over
\(W(k_0)\); full faithfulness retains actions, transition maps, and their
relations. These are substantial supported steps, not failures caused by
missing software. The archived independent citation receipt for
Lieblich--Olsson is `citation-A_LO_ROOTS-dc4148aed596`; Rydh has
`judgement-A_RYDH_PROPER-f4ec4daf5e32` and the retained primary excerpts.

## Concrete outstanding obligation F1

The load-bearing sentence is:

> Base change to the strictly henselian \(W(\bar k_0)\) and then to
> \(\bar D\) supplies the specified semilinear action, because the whole
> construction was over \(W(k_0)\).

Here \(W(\bar k_0)\) is a complete unramified Witt trait; its fraction
field is not identified with the algebraic closure
\(\bar D\) of \(\operatorname{Frac}W(k_0)\). In particular the displayed
phrase does not specify a ring map or a comparison permitting that
successive base change. Completion of the maximal unramified extension,
its algebraic union, and an algebraic closure cannot simply be interchanged.
The component lemma proves an assertion on a specified complete strictly
henselian trait; it does not, by itself, compare these different generic
bases.

**F1:** provide the precise comparison/descent of the lifted finite
root-stack torsors and their framed geometric components to the claimed
\(\bar D\)-fiber, compatibly with every root index, quotient map, and
the chosen arithmetic action. The comparison must identify the same
geometric image and all boundary transports \(B_i\), not merely individual
isomorphism classes of covers. The \(q\)-Witt action restricts to the
identity on \(W(k_0)\); an unspecified extension of that restriction to
\(\bar D\) alone does not identify its action on all unramified residue
extensions with the intended Frobenius.

The old independent primary excerpt explicitly warns that Rydh's theorem
“does not identify the two generic coefficient fields in Section 3.”
Neither that theorem nor the quoted root-stack result supplies F1 as
written. A comparison might be obtainable; this review neither supplies a
repair nor proves the mathematical conclusion false.

## Propagation and computation scope

Without F1, the claim about the full arithmetic system over \(\bar D\)
and its exact geometric image is not established by this draft. This
blocks the unconditional use of its output in `C_ABG` and the arithmetic
applications of gluing and density. It does **not** invalidate the
conditional gluing argument or the component lemma on their own bases.

The successful [finite replay](../computation/replay.json) checks matrix
and finite-congruence identities, not F1, proper base change, or an infinite
arithmetic torsor tower. There is no Lean source. The gap is therefore a
specific mathematical comparison obligation, not a run failure or a
blanket verdict on the reference manuscripts. Native independent review
of this assessment remains pending.
