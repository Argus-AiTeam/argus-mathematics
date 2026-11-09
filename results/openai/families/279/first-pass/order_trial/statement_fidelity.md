# Statement fidelity: algebraic core of the order-trial verification

`Main.lean` uses Lean 4.31.0 and Mathlib. It proves exact universally
quantified algebraic statements, not a formal model of quantum circuits.

The declarations `OrderTrial.R0`, `I0`, `R1`, `I1`, `R2`, and `I2` are
the real and imaginary coordinates of integrals of the polygonal phase in
the coordinate `w = 4z`. They are unnormalized integrals in `w`.
Quarter-turn multiplication has unit modulus, and division by the interval
length converts each pair into the phase average. These identifications,
the reduction to the three sectors, and the zero-length case are proved
in the mathematical report, not inside Lean.

`OrderTrial.sector_zero` quantifies over arbitrary real `s,a`, without
hypotheses, and proves `R0^2+I0^2 >= a^2/4`. Its application uses
`0 <= s <= 1` and `0 <= a <= 1-s`.

`OrderTrial.sector_one` quantifies over real `x,y` with
`0 <= x <= 1` and `0 <= y <= 1`. It proves
`R1^2+I1^2 >= (x+y)^2/4`. Here `x` and `y` are the portions before
and after one crossed vertex, and the interval length is `x+y`.

`OrderTrial.sector_two` quantifies over real `x,y` with `x,y >= 0` and
`x+y <= 1`. It proves `R2^2+I2^2 >= (1+x+y)^2/4`. The interval
contains one whole segment and two partial segments. The length is
`1+x+y`. `OrderTrial.sharp_endpoint` proves equality at `x=1,y=0`,
which corresponds to an interval of two quarter segments. Thus the
resulting average-modulus bound `1/2` is sharp.

`OrderTrial.power_sum_one`, `power_sum_two`, `power_sum_three`, and
`power_sum_four` quantify over every natural `M`. The sums are over
`0 <= i < M`, with powers and closed formulas evaluated in the rationals.
They justify constant-degree polynomial summation without iterating
through the residues. The degree-zero formula is simply the count.

`OrderTrial.correction_mass` quantifies over arbitrary rationals
`P,U,c,rho,S,lam`, assumes `S=U/2` and `rho=lam-c*S`, and proves the
three-mode mass identity. Here `P,U` denote sums over residues, not
individual residue values. The theorem does not prove probability
validity, the floor bounds, or the correspondence to a quantum event.

The mechanical ledger claim `C_SECTOR_BOUND` is restricted to the three
sector inequalities. The other declarations are additional exact algebraic
facts. The larger claims `C_POLYGON_CORE` and `C_ORDER_TRIAL` also require
the report's mathematical arguments and independent statement-fidelity
review. No compilation of this file certifies the full factoring theorem.
