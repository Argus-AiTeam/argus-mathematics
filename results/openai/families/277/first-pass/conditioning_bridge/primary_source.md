# Primary-source reading and scope

The target is `build/sections/04-threshold.tex`, Propositions
`song-conditioning` and `conditioning-to-tail`, in the staged September 25,
2026 manuscript. No false literal assertion has been established.

## Song's actual statement

Source: Zhao Song, *Parallel Repetition for Entangled Games with Gap Exponent
Three*, ECCC TR26-199, manuscript dated August 5, 2026; report page publication
timestamp September 20, 2026 17:48.

Official document: <https://eccc.weizmann.ac.il/report/2026/199/download/>.
The report page and PDF endpoint were opened. Direct shell downloads failed
with curl exit 56 (TLS connection reset). The official 17-page PDF was
text-extracted through the public Jina reader of that exact official URL.
`song-primary-extract-1.txt` and `song-primary-extract-2.txt` preserve the
returned text, including extraction defects in fractions and subscripts.
This is a PDF-text reading, not a local byte-for-byte PDF verification.

Definition 4.3, PDF p. 11, fixes an arbitrary finite-dimensional repeated
strategy and a proper subset D0 of [n] with p = Pr[W_D0] > 0, and defines

    m = n - |D0|,
    q = (1/m) sum_{i outside D0} Pr[W_i | W_D0],
    eta = (log(1/p) + |D0| log(|A||B|))/m.

Immediately before Lemma 4.4, the source explicitly states: "Here we make no
assumption that the ideal conditioned experiment wins with probability close
to one." Lemma 4.4, PDF pp. 11-12, states that a universal B4 >= 1 satisfies

    0 <= eta <= 1  ==>  omega*(G) >= q - B4 eta^(1/4).

Renaming D0, n, eta to C, k, tau and rearranging gives exactly the
manuscript's Proposition `song-conditioning`. Section 3.1 permits arbitrary
finite question distributions and nonempty answer alphabets; no full-support,
connected-support, dimension bound, or attainment hypothesis is present.

## Dependency boundary

Lemma 4.4 invokes Song Lemmas 3.2 and 3.3 (ideal coordinate simulation and
postselected state alignment/history sampleability), themselves imported from
OpenAI Chapter 6, and Song's smooth operational sampler, Lemma 4.1.
The source's error calculation is

    E_Q s <= Csm D^(1/4) + zeta + 4 sqrt(2 eta),
    win >= q - (E_Q s)/2 - 6 sqrt(3 eta/2),
    D <= 32 eta.

For 0 <= eta <= 1, sqrt(eta) <= eta^(1/4), so a universal B4 absorbs
these terms. Every zeta > 0 gives a finite-dimensional strategy; taking its
supremum and then zeta down to zero does not require attaining that supremum.
This verifies the citation's applicability. It does not independently
formalize or certify the underlying quantum sampler or Chapter 6 lemmas.

## Already known and not claimed as new

The staged manuscript already proves the generic transfer in prose. Song's
fourth-root rounding statement and the fifth-power substitution are existing
results, not a new theorem discovered by a citation lookup. The substantive
certificate sought here is a complete independent formal verification of the
generic transfer for finite binary-law families, under precisely delimited
conditioning and independent-product closure hypotheses.

Checking a finite collection of laws, or merely proving the scalar rate
arithmetic, would not establish this universally quantified transfer.
Neither route is being offered as its proof.
