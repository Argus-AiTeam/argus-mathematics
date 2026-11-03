# Jacobian adapter executable

When the math role banner reports Jacobian capability, invoke the Argus adapter
with this exact interpreter:

`/home/argustest/zimo/argus-live-update/.venv/bin/python -m argus_skill.tools.jacobian`

Do not probe the adapter with
`/home/argustest/zimo/argus-latest/.venv/bin/python`; that older environment is
kept for legacy math-state commands and does not contain the Jacobian adapter.
An adapter failure from that old interpreter is not evidence that Jacobian is
unavailable. Continue to inspect before running an unfamiliar operation and
preserve the exact typed result.

Always keep Jacobian payloads and outputs in dedicated `.json` files. Never
replace a human-readable evidence README, proof note, CSV, or source file with
a typed payload merely to pass `--payload-file`.
