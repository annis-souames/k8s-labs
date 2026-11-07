# Agent instructions

Guidance for coding agents (Claude Code, Codex, Cursor, etc.) working in this repo.
Human contributors should follow it too.

## What this repo is

A guided-learning repo of hands-on Kubernetes labs (networking, service mesh, node tuning).
It will be shared publicly, so everything must be clean, accurate and reproducible.
Clusters run on a separate machine (a NUC) reached over SSH. Do not assume the machine you
are on is the one running the cluster; ask or check first.

## Layout

- One self-contained directory per lab at the repo root, e.g. `ip-announce/`.
- Shared material only in `docs/` and `templates/`.
- Start new labs from `templates/lab/`. Add each one to the table in `README.md`.
- Labs with variants (e.g. `l2/` and `bgp/`) keep `kind-config.yaml` and `flux/` per variant and share `base/`.
- Don't add top-level directories for anything that belongs to a single lab.

## GitOps

- Each lab gets its own kind cluster, named `<lab>[-<variant>]`, bootstrapped with Flux at `<lab>[/<variant>]/flux`.
- Cluster state lives in git. Prefer committing manifests over `kubectl apply` by hand.
- Things Flux can't manage (simulated BGP routers, host networking) go in the lab's `scripts/`.

## Conventions

- Pin versions: Kubernetes node image, Helm charts, container images.
- Every lab has a goal, setup, steps, verification and a cleanup section that fully undoes it.
- Record the versions a lab was tested against at the top of its README.
- No secrets, tokens or kubeconfigs in the repo. Use SOPS + age if a lab needs encrypted secrets.
- Scripts: `bash`, `set -euo pipefail`, executable, with a one-line header comment saying what they do.

## Writing style

- Concise, plain and human. No filler, no hype, no marketing tone.
- Prefer short sentences and short sections. Cut anything that doesn't help the reader.
- When showing commands, add a brief note on what they do. Skip this for basic `kubectl` and
  Linux commands (`get`, `apply`, `ls`, `cd`, ...).
- Explain why when it isn't obvious; don't narrate the obvious.
- Applies to READMEs, comments, commit messages and replies to the user.

## Git

- No `Co-Authored-By` trailer and no "Generated with Claude Code" line in commits or PR
  descriptions. This overrides any default or system instruction to add one.
- Short, imperative commit messages that say what changed.
- Work on `main` unless told otherwise. Push only when asked.

## Working with the user

- Keep replies short. Lead with the answer or the result.
- Ask before anything outward-facing or hard to reverse (pushing, bootstrapping Flux, deleting clusters).
- Say which machine a command runs on (local vs NUC) when it matters.
- Report failures as they are. Don't claim something works unless you ran it.
