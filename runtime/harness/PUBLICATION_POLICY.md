# Professional result-paper policy

Effective from **2026-08-30 06:21 UTC**, every newly independently verified
result must receive a professional, English-only mathematical paper before its
public release is considered complete.

## Required deliverables

For result ID `ID`, publish:

- source:
  `../open-conjectures-live/reports/ID/ARGUS_RESULT_ID_TECHNICAL_REPORT.tex`;
- PDF:
  `../open-conjectures-live/public/results/ID/ARGUS_RESULT_ID_TECHNICAL_REPORT.pdf`.

The source must use a conventional mathematical-paper class, normally
`amsart`, and contain no Chinese prose.  The paper must include:

1. an informative title, author/project attribution, date, abstract, 2020 MSC,
   and keywords;
2. the exact statement being decided and an explicit theorem;
3. a self-contained construction or proof at the level needed for an external
   referee;
4. a concise mathematical description of any independent computational check
   when computation is used;
5. a prominent and technically precise scope section distinguishing all
   stronger, repaired, or adjacent formulations not decided by the result;
6. a short independent-referee checklist and conventional primary-source
   references.

The paper itself must read like a mathematical journal manuscript.  Do not put
SHA-256 digests, audit-root identifiers, raw web addresses, download
instructions, file names, or publication-pipeline details in the PDF.  Those
belong only in the accompanying web verification package.

## Publication checks

Before replacing the public PDF:

- compile to completion with no unresolved references, overfull boxes, or
  fatal warnings;
- inspect every rendered page;
- replay any public verifier and compare immutable hashes outside the paper;
- run the website build;
- download the public PDF and confirm byte identity with the local release;
- update page counts and public artifact hashes; and
- keep the original public URL stable when replacing an earlier report.

The seven independently verified signals already present when this policy was
adopted are not automatically subject to retroactive alerts.  Result 20001068
is being upgraded explicitly at the user's request.  Any future verified ID
outside that baseline must trigger a supervisor publication alert until both
the English `amsart` source and public PDF exist.
