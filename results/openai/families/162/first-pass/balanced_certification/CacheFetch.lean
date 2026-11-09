import Cache.Requests

def main : IO Unit := Cache.IO.CacheM.run do
  let source ← Lean.findLean (← read).srcSearchPath `Mathlib
  let roots := ({} : Std.HashMap Lean.Name System.FilePath).insert `Mathlib source
  let memo ← Cache.Hashing.getHashMemo roots
  Cache.Requests.scopeOverride.set (some "d13f23b723b8a846827a245b89c10fc7d3f11612")
  Cache.Requests.getFiles "leanprover-community/mathlib4" memo.hashMap false false true true
