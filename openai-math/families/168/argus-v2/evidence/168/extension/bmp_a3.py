#!/usr/bin/env python3
"""Construct the two singular S4 BMP sheaves by exact boundary-image covers.

The top stalk is Q[a,b,c]. At x, compute all sections strictly above x,
map them to outgoing edge stalks, and choose a basis modulo T+(a,b,c)N.
Here N consists of lifted boundary generators and T of edge-label relations.
The selected lifts give the actual graded minimal free cover of (N+T)/T.
"""

import argparse
import itertools
import json
import subprocess
from pathlib import Path


def length(w):
    return sum(a > b for i, a in enumerate(w) for b in w[i + 1 :])


def bruhat(x, y):
    return all(
        sum(a >= q for a in x[:p]) <= sum(a >= q for a in y[:p])
        for p in range(1, 5)
        for q in range(1, 5)
    )


def name(w):
    return "".join(map(str, w))


def interval(top):
    return sorted(
        (w for w in itertools.permutations(range(1, 5)) if bruhat(w, top)),
        key=lambda w: (-length(w), w),
    )


def edges(vertices):
    result = []
    vertex_set = set(vertices)
    roots = ("a", "b", "c")
    for x in vertices:
        for i, j in itertools.combinations(range(1, 5), 2):
            y = tuple(j if z == i else i if z == j else z for z in x)
            if y in vertex_set and length(x) < length(y):
                result.append((x, y, "+".join(roots[i - 1 : j - 1])))
    return sorted(result, key=lambda e: (e[0], e[1]))


PRELUDE = r"""
ring A=0,(a,b,c),dp;
proc identity(int n)
{
  matrix M[n][n];
  int i;
  for(i=1;i<=n;i++){M[i,i]=1;}
  return(M);
}
proc cover(module N,module T)
{
  module mN=a*N,b*N,c*N;
  module base=T,mN;
  module G=std(base);
  module chosen;
  int j;
  for(j=1;j<=ncols(N);j++)
  {
    if(reduce(N[j],G)!=0)
    {
      chosen=chosen,N[j];
      base=base,N[j];
      G=std(base);
    }
  }
  return(simplify(chosen,2));
}
proc emit(string tag,matrix M)
{
  print("@@"+tag+"|"+string(nrows(M))+"|"+string(ncols(M))+"|"+string(M));
}
"""


def program(top, all_subsets=True):
    vertices = interval(top)
    graph = edges(vertices)
    out = [PRELUDE, f"int r{name(top)}=1;"]
    out.append(f'print("@@RANK|{name(top)}|1");')
    for x in vertices[1:]:
        sx = name(x)
        upper = [v for v in vertices if v != x and bruhat(x, v)]
        internal = [(v, y, a) for v, y, a in graph if v in upper and y in upper]
        outgoing = [(v, y, a) for v, y, a in graph if v == x]
        offset = {}
        count = "0"
        for v in upper:
            offset[v] = count
            count += f"+r{name(v)}"
        neq = "0" + "".join(f"+r{name(y)}" for _, y, _ in internal)
        if internal:
            out.append(f"matrix Q{sx}[{neq}][{count}+{neq}];")
            row = "0"
            for v, y, a in internal:
                sv, sy = name(v), name(y)
                out.append(
                    f"for(int i=1;i<=r{sy};i++){{"
                    f"for(int j=1;j<=r{sv};j++){{"
                    f"Q{sx}[{row}+i,{offset[v]}+j]=E{sv}_{sy}[i,j];}}"
                    f"Q{sx}[{row}+i,{offset[y]}+i]=-1;"
                    f"Q{sx}[{row}+i,{count}+{row}+i]=({a});}}"
                )
                row += f"+r{sy}"
            out.append(f"matrix Z{sx}=syz(Q{sx});")
            out.append(f"matrix S{sx}[{count}][ncols(Z{sx})];")
            out.append(
                f"for(int i=1;i<={count};i++){{"
                f"for(int j=1;j<=ncols(Z{sx});j++){{"
                f"S{sx}[i,j]=Z{sx}[i,j];}}}}"
            )
        else:
            out.append(f"matrix S{sx}=identity({count});")
        nboundary = "0" + "".join(f"+r{name(y)}" for _, y, _ in outgoing)
        out.append(f"matrix D{sx}[{nboundary}][{count}];")
        out.append(f"matrix T{sx}[{nboundary}][{nboundary}];")
        row = "0"
        for _, y, a in outgoing:
            sy = name(y)
            out.append(
                f"for(int i=1;i<=r{sy};i++){{"
                f"D{sx}[{row}+i,{offset[y]}+i]=1;"
                f"T{sx}[{row}+i,{row}+i]=({a});}}"
            )
            row += f"+r{sy}"
        out.append(f"module N{sx}=D{sx}*S{sx};")
        out.append(f"matrix C{sx}=cover(N{sx},T{sx});")
        out.append(f"int r{sx}=ncols(C{sx});")
        out.append(f'print("@@RANK|{sx}|"+string(r{sx}));')
        row = "0"
        for _, y, a in outgoing:
            sy = name(y)
            out.append(f"matrix E{sx}_{sy}[r{sy}][r{sx}];")
            out.append(
                f"for(int i=1;i<=r{sy};i++){{"
                f"for(int j=1;j<=r{sx};j++){{"
                f"E{sx}_{sy}[i,j]=C{sx}[{row}+i,j];}}}}"
            )
            out.append(f'emit("MAP|{sx}|{sy}|{a}",E{sx}_{sy});')
            row += f"+r{sy}"
    if all_subsets:
        for x in vertices:
            sx = name(x)
            outgoing = [(v, y, a) for v, y, a in graph if v == x]
            for mask in range(1 << len(outgoing)):
                chosen = [e for k, e in enumerate(outgoing) if mask & (1 << k)]
                if not chosen:
                    out.append(f'emit("KERNEL|{sx}|{mask}",identity(r{sx}));')
                    continue
                rows = "0" + "".join(f"+r{name(y)}" for _, y, _ in chosen)
                identifier = f"K{sx}_{mask}"
                out.append(f"matrix {identifier}Q[{rows}][r{sx}+{rows}];")
                row = "0"
                for _, y, a in chosen:
                    sy = name(y)
                    out.append(
                        f"for(int i=1;i<=r{sy};i++){{"
                        f"for(int j=1;j<=r{sx};j++){{"
                        f"{identifier}Q[{row}+i,j]=E{sx}_{sy}[i,j];}}"
                        f"{identifier}Q[{row}+i,r{sx}+{row}+i]=({a});}}"
                    )
                    row += f"+r{sy}"
                out.append(f"matrix {identifier}Z=syz({identifier}Q);")
                out.append(f"matrix {identifier}P[r{sx}][ncols({identifier}Z)];")
                out.append(
                    f"for(int i=1;i<=r{sx};i++){{"
                    f"for(int j=1;j<=ncols({identifier}Z);j++){{"
                    f"{identifier}P[i,j]={identifier}Z[i,j];}}}}"
                )
                out.append(f"module {identifier}T;")
                out.append(f"matrix {identifier}=cover({identifier}P,{identifier}T);")
                out.append(f'emit("KERNEL|{sx}|{mask}",{identifier});')
                out.append(f'emit("RELATION|{sx}|{mask}",syz({identifier}));')
    out.append("quit;")
    return "\n".join(out)


def run(top, all_subsets=True):
    source = program(top, all_subsets)
    result = subprocess.run(
        ["Singular", "-q"],
        input=source,
        text=True,
        capture_output=True,
        check=True,
        timeout=120,
    )
    if "?" in result.stdout or result.stderr:
        raise RuntimeError(result.stdout + result.stderr)
    records = [line[2:].split("|") for line in result.stdout.splitlines() if line.startswith("@@")]
    return {"top": name(top), "records": records}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--top", choices=("3412", "4231"), required=True)
    parser.add_argument("--output", type=Path)
    parser.add_argument("--singular-source", type=Path)
    args = parser.parse_args()
    top = tuple(map(int, args.top))
    if args.singular_source:
        args.singular_source.write_text(program(top))
    result = run(top)
    if args.output:
        args.output.write_text(json.dumps(result, indent=2) + "\n")
    ranks = {r[1]: int(r[2]) for r in result["records"] if r[0] == "RANK"}
    nonfree = [r for r in result["records"] if r[0] == "KERNEL" and int(r[4]) > ranks[r[1]]]
    print(json.dumps({"ranks": ranks, "nonfree_kernels": nonfree}, indent=2))


if __name__ == "__main__":
    main()
