#!/usr/bin/env python3
"""Replay exact leaf signs and coverage, never infer a proof from a run log."""

import argparse
from copy import deepcopy
from fractions import Fraction as Q
import hashlib
from itertools import permutations, product
import json
from pathlib import Path
import re
import subprocess
import sys


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PAPER = ROOT / "research/openai_manuscript/The-Reconstruction-Threshold-for-the-Ferromagnetic-Four-State-Potts-Model-October-5-2026"
CHECKS = PAPER / "verification/checks"
L = ((1,1,-1,-1),(1,-1,1,-1),(1,-1,-1,1))
ROWS = {
    "H": [0,0,1000,-100,-150,300,-20,70,-510],
    "F": [0,4000,-3000,700,-4000,-800,0,0,0],
    "G": [1000,-1610,-3100,773,4000,-3980,0,0,0],
}
DEGREES = [0,2,3,4,4,5,6,6,6]
PERMUTATIONS = tuple(permutations(range(4)))


def require(condition, message):
    if not condition:
        raise ValueError(message)


def scalar(p):
    x = [sum(a*b for a,b in zip(row,p)) for row in L]
    A = sum(a*a for a in x)
    B = x[0]*x[1]*x[2]
    C = sum(x[i]**2*x[j]**2 for i,j in ((0,1),(0,2),(1,2)))
    basis = (1,A,B,A*A,C,A*B,A**3,A*C,B*B)
    return A, {
        name: sum(Q(c,1000)*v for c,v in zip(row,basis))
        for name,row in ROWS.items()
    }


def probability(p):
    require(len(p)==4 and all(v>=0 for v in p) and sum(p)==1,
            "Witness is outside the probability simplex")


def slacks(p,q):
    probability(p)
    probability(q)
    ap,fp = scalar(p)
    aq,fq = scalar(q)
    za = zh = Q(0)
    zeros = 0
    for pi in PERMUTATIONS:
        U = [4*p[i]*q[pi[i]] for i in range(4)]
        z = sum(U)
        if not z:
            require(all(v==0 for v in U),"Nonnegative zero-mass vector is not zero")
            zeros += 1
            continue
        A,F = scalar([v/z for v in U])
        za += z*A/24
        zh += z*F["H"]/24
    return (
        ap+aq-fp["H"]*fq["F"]-fp["F"]*fq["H"]
        -ap*aq*(ap+aq)/1000-za,
        zh-fp["H"]*fq["G"]-fp["G"]*fq["H"],
        zeros,
    )


def reject_counterexample(p,q,row):
    a,b,_ = slacks(p,q)
    require((a,b)[row]<0,"Claimed counterexample has no negative slack")


def multiply(a,b):
    out = [0]*(len(a)+len(b)-1)
    for i,x in enumerate(a):
        for j,y in enumerate(b):
            out[i+j] += x*y
    return out


def polynomial_power(a,n):
    out = [1]
    for _ in range(n):
        out = multiply(out,a)
    return out


def check_taylor(certificate):
    quotients = certificate["taylor_remainder_quotients_ascending"]
    require(quotients=={"1":[1],"5":[1,6,21,56,126]},
            "Corrupt Taylor remainder quotient")
    for k in (1,5):
        t = [Q(0)]*6
        coefficient = Q(1)
        for i in range(6):
            for j,value in enumerate(polynomial_power([-1,1],i)):
                t[j] += coefficient*value
            coefficient *= Q(-k-i,i+1)
        left = [Q(0)]*(k+6)
        left[0] = 1
        for i,value in enumerate(t):
            left[k+i] -= value
        right = multiply(polynomial_power([-1,1],6),quotients[str(k)])
        require(left==right,"Reciprocal lower-bound identity failed")
        require(all(v>=0 for v in quotients[str(k)]),
                "Taylor remainder lacks a nonnegative monomial certificate")


def source_binding(certificate):
    cone = (PAPER / "build/sections/03-cone.tex").read_text()
    experiments = (PAPER / "build/sections/02-experiments.tex").read_text()
    source = (CHECKS / "certificate.cpp").read_text()
    for name,row in ROWS.items():
        match = re.search(r"^\s*"+name+r"&([^\n\\]+)",cone,re.M)
        require(match is not None,f"Missing manuscript coefficient row {name}")
        literal = [int(v.strip()) for v in match.group(1).split("&")]
        require(literal==row==certificate["coefficients_divided_by_1000"][name],
                f"Literal manuscript row {name} differs from certificate")
        match = re.search(r"vector<R>\s*"+name.lower()+r"=\{([^}]+)\}",source)
        require(match is not None,f"Missing C++ coefficient row {name}")
        require([int(v) for v in match.group(1).split(",")]==row,
                f"C++ coefficient row {name} differs from manuscript")
    matrix = re.search(r"L=\s*\\begin\{pmatrix\}(.*?)\\end\{pmatrix\}",
                       experiments,re.S)
    require(matrix is not None,"Missing manuscript coordinate matrix")
    literal_L = [
        tuple(int(v.strip()) for v in row.split("&"))
        for row in matrix.group(1).strip().split(r"\\")
    ]
    require(tuple(literal_L)==L and certificate["L"]==[list(row) for row in L],
            "Coordinate matrix is not the literal manuscript matrix")
    require(certificate["basis_degrees"]==DEGREES,"Wrong invariant degrees")
    require(certificate["permutation_count"]==certificate["average_denominator"]==24,
            "Permutation average normalization changed")
    require(certificate["zero_overlap_summand"]=="0","Wrong zero-overlap convention")
    recorded = json.loads((CHECKS / "full-runs.json").read_text())
    require(hashlib.sha256((CHECKS / "certificate.cpp").read_bytes()).hexdigest()
            ==recorded["source_sha256"],"Reused coefficient engine is not the retained source")
    return recorded


def symmetry_and_boundary():
    require(len(PERMUTATIONS)==len(set(PERMUTATIONS))==24,
            "Relative permutations are not enumerated exactly once")
    for pi in PERMUTATIONS:
        T = [[sum(Q(L[i][k]*L[j][pi[k]],4) for k in range(4))
              for j in range(3)] for i in range(3)]
        require(all(sum(v!=0 for v in row)==1 for row in T),
                "A probability permutation does not permute coordinate axes")
        require(all(sum(T[i][j]!=0 for i in range(3))==1 for j in range(3)),
                "Coordinate permutation has a repeated axis")
        entries = [v for row in T for v in row if v]
        require(all(abs(v)==1 for v in entries) and entries[0]*entries[1]*entries[2]==1,
                "Invariant B does not survive the sign changes")
    # |x_i|<=1 implies A<=3, |B|<=1, C<=3 and the following absolute bound.
    h_bound = sum(Q(abs(c),1000)*b for c,b in zip(ROWS["H"],
                  (1,3,1,9,3,3,27,9,1)))
    require(h_bound==Q(493,100),"Unexpected continuity bound")
    for pi in PERMUTATIONS:
        require(sorted(pi)==list(range(4)),"Permutation lost a state")
    return {"A_absolute_bound":"3","H_absolute_bound":str(h_bound)}


def adversarial_pairs():
    points = set()
    for denominator in range(1,7):
        for a,b,c in product(range(denominator+1),repeat=3):
            d=denominator-a-b-c
            if a>=b>=c>=d>=0:
                points.add(tuple(Q(v,denominator) for v in (a,b,c,d)))
    uniform = (Q(1,4),)*4
    for exponent in (4,8,16):
        epsilon = Q(1,2**exponent)
        for direction in ((3,-1,-1,-1),(1,1,-1,-1),(1,0,0,-1)):
            points.add(tuple(u+epsilon*v for u,v in zip(uniform,direction)))
    zero_pairs = 0
    for p,q in product(sorted(points),repeat=2):
        a,b,zeros = slacks(p,q)
        require(a>=0 and b>=0,f"Exact counterexample found: p={p}, q={q}, slacks={(a,b)}")
        zero_pairs += bool(zeros)
    return {"probability_vectors":len(points),"pairs":len(points)**2,
            "pairs_with_zero_overlap":zero_pairs,"arithmetic":"fractions.Fraction"}


def tree_structure(tree):
    require(isinstance(tree,list) and tree,"Missing replayable proof tree")
    position = 0
    stats = {"visited":0,"max_depth":0,"type_t_leaves":0,"type_p_leaves":0}

    def visit(depth):
        nonlocal position
        require(depth<=24,"Proof tree exceeds midpoint exactness bound")
        require(position<len(tree),"Proof tree omits a child")
        instruction = tree[position]
        position += 1
        stats["visited"] += 1
        stats["max_depth"] = max(stats["max_depth"],depth)
        require(isinstance(instruction,list) and instruction,"Malformed proof-tree datum")
        if instruction==["T"]:
            stats["type_t_leaves"] += 1
        elif instruction==["P"]:
            stats["type_p_leaves"] += 1
        else:
            require(len(instruction)==4 and instruction[0]=="S",
                    "Unknown proof-tree instruction")
            _,axis,i,j = instruction
            require(type(axis) is int and axis in (0,1)
                    and type(i) is int and type(j) is int and 0<=j<i<4,
                    "Invalid subdivision datum")
            visit(depth+1)
            visit(depth+1)

    visit(0)
    require(position==len(tree),"Proof tree has trailing uncovered data")
    leaves = stats["type_t_leaves"]+stats["type_p_leaves"]
    require(stats["visited"]==2*leaves-1,"Proof tree is not a full binary cover")
    return stats


def compile_checker():
    binary = HERE / "replay"
    subprocess.run(["g++","-std=c++17","-O3","-UNDEBUG",str(HERE/"replay.cpp"),
                    "-o",str(binary)],check=True,capture_output=True,text=True)
    return binary


def parse_trace(output):
    lines = output.splitlines()
    require(lines and lines[-1].startswith("RESULT "),"Missing computed leaf-sign result")
    stats = json.loads(lines[-1][7:])
    tree = []
    for line in lines[:-1]:
        fields = line.split()
        require(fields and fields[0] in ("S","T","P"),"Malformed generated proof trace")
        tree.append([fields[0]]+[int(v) for v in fields[1:]])
    return tree,stats


def replay(binary,row,tree,build):
    input_text = None
    if not build:
        input_text = "".join(" ".join(str(v) for v in instruction)+"\n"
                             for instruction in tree)
    log = HERE / f"row_{row}_{'build' if build else 'replay'}.log"
    with log.open("w") as stderr:
        result = subprocess.run([str(binary),"build" if build else "verify",row],
                                input=input_text,stdout=subprocess.PIPE,stderr=stderr,text=True)
    require(result.returncode==0,f"Exact row {row} computation failed; see {log}")
    output_tree,stats = parse_trace(result.stdout)
    if build:
        tree = output_tree
    else:
        require(not output_tree,"Replay unexpectedly generated a replacement proof tree")
    require(tree_structure(tree)==stats,f"Row {row} signs and coverage disagree")
    return tree,stats


def rejection_tests(certificate,binary):
    bad = deepcopy(certificate)
    bad["taylor_remainder_quotients_ascending"]["5"][0] += 1
    tests = [
        lambda: check_taylor(bad),
        lambda: tree_structure([["S",0,3,0],["T"]]),
        lambda: tree_structure([["S",2,3,0],["T"],["T"]]),
        lambda: reject_counterexample((Q(2),Q(-1),Q(0),Q(0)),(Q(1,4),)*4,0),
        lambda: reject_counterexample((Q(1,4),)*4,(Q(1,4),)*4,1),
    ]
    for test in tests:
        try:
            test()
        except ValueError:
            pass
        else:
            raise ValueError("An intentionally invalid proof datum or witness was accepted")
    result = subprocess.run([str(binary),"verify","a"],input="T\n",
                            capture_output=True,text=True)
    require(result.returncode!=0 and "Type T leaf has a negative coefficient" in result.stderr,
            "A forged positive root certificate was not rejected by exact signs")
    return 6


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--certificate",type=Path,default=HERE/"exact_certificate.json")
    parser.add_argument("--build-certificate",action="store_true",
                        help="Construct the finite tree; ordinary replay never replaces its input.")
    parser.add_argument("--self-test",action="store_true")
    args = parser.parse_args()
    certificate = json.loads(args.certificate.read_text())
    require(certificate["claim"]=="C_CONE_CORE_4","Wrong target claim")
    provenance = source_binding(certificate)
    check_taylor(certificate)
    boundary = symmetry_and_boundary()
    small = subprocess.run([sys.executable,str(CHECKS/"small_polynomials.py")],
                           check=True,capture_output=True,text=True)
    scalars = json.loads(small.stdout)
    minima = {item["name"]:item["minimum"] for item in scalars["small_checks"]}
    require(minima==certificate["scalar_minima"],"Scalar sign certificate mismatch")
    require(scalars["all_24_symmetry_actions_verified"],"Scalar symmetry certificate failed")
    measured = adversarial_pairs()
    print(json.dumps({"source_binding":"passed","exact_adversarial_test":measured,
                      "boundary_bounds":boundary}),flush=True)
    binary = compile_checker()
    results = {}
    for row,k,m in (("a",1,"3"),("b",5,"1/2")):
        datum = certificate["rows"][row]
        require(datum["k"]==k and datum["m"]==m,"Wrong rational certificate row")
        if not args.build_certificate:
            require(certificate["complete"] is True,"Certificate construction is incomplete")
            require(tree_structure(datum["tree"])==datum["computed_statistics"],
                    "Recorded coverage statistics do not describe the supplied proof")
        tree,stats = replay(binary,row,datum["tree"],args.build_certificate)
        results[row] = stats
        if args.build_certificate:
            datum["tree"] = tree
            datum["computed_statistics"] = stats
            args.certificate.write_text(json.dumps(certificate,indent=2)+"\n")
        print(json.dumps({"row":row,"exact_leaf_signs":"passed","coverage":stats}),flush=True)
    if args.build_certificate:
        certificate["complete"] = True
        certificate["adversarial_test"] = measured
        certificate["boundary_bounds"] = boundary
        certificate["author_reported_statistics_not_used_as_proof"] = {
            row:provenance["runs"][row]["completion"] for row in ("a","b")
        }
        args.certificate.write_text(json.dumps(certificate,indent=2)+"\n")
    rejected = rejection_tests(certificate,binary) if args.self_test else 0
    print(json.dumps({"verified":True,"claim":"C_CONE_CORE_4",
                      "proof":"fresh exact leaf signs and complete subdivision cover",
                      "invalid_inputs_rejected":rejected,
                      "independent_review":"pending"}),flush=True)


if __name__=="__main__":
    try:
        main()
    except (ValueError,KeyError,TypeError,json.JSONDecodeError,
            subprocess.CalledProcessError) as error:
        print(f"REJECTED: {error}",file=sys.stderr)
        sys.exit(1)
