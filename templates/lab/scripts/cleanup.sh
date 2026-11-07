#!/usr/bin/env bash
# Delete the kind cluster for this lab. Remove the Flux deploy key from the repo manually
# (Settings -> Deploy keys) or with `gh repo deploy-key delete`.
# Usage: scripts/cleanup.sh [variant]
set -euo pipefail

LAB_NAME="$(basename "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)")"
kind delete cluster --name "${LAB_NAME}${1:+-$1}"
