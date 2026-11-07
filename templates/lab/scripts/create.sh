#!/usr/bin/env bash
# Create the kind cluster for this lab and bootstrap Flux against this repo.
# Usage: scripts/create.sh [variant]   (variant = subdirectory holding kind-config.yaml and flux/)
set -euo pipefail

LAB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LAB_NAME="$(basename "$LAB_DIR")"
VARIANT="${1:-.}"
CLUSTER="${LAB_NAME}${1:+-$1}"
REPO_PATH="$(realpath --relative-to="$(git -C "$LAB_DIR" rev-parse --show-toplevel)" "$LAB_DIR/$VARIANT")"

: "${GITHUB_OWNER:?set GITHUB_OWNER}"
: "${GITHUB_TOKEN:?set GITHUB_TOKEN (repo scope), e.g. export GITHUB_TOKEN=\$(gh auth token)}"

kind create cluster --name "$CLUSTER" --config "$LAB_DIR/$VARIANT/kind-config.yaml"
kubectl config use-context "kind-$CLUSTER"

flux bootstrap github \
  --owner="$GITHUB_OWNER" --repository=k8s-labs \
  --branch=main --path="$REPO_PATH/flux" --personal
