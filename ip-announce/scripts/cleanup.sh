#!/usr/bin/env bash
# Remove everything the lab created: cluster, FRR containers, client and Docker networks.
# Does not remove the Flux deploy key from GitHub (Settings -> Deploy keys).
set -uo pipefail
cd "$(dirname "$0")/.."
source scripts/env.sh

kind delete cluster --name "$CLUSTER"
docker rm -f spine1 spine2 leaf1 leaf2 leaf3 client 2>/dev/null
for net in s1l1 s1l2 s1l3 s2l1 s2l2 s2l3 rack1 rack2 border; do
    docker network rm "ia-$net" 2>/dev/null
done
true
