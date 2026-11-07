#!/usr/bin/env bash
# Check that the lab works. Exit non-zero on failure.
set -euo pipefail

flux get kustomizations
# Add lab-specific checks here.
