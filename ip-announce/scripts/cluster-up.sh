#!/usr/bin/env bash
# Create the kind cluster and plug its workers into the rack networks.
set -euo pipefail
cd "$(dirname "$0")/.."
source scripts/env.sh

kind create cluster --config kind-config.yaml

# wire <node> <rack> <ip>
# Adds a second NIC on the rack network (this is where BGP runs) and a route to the whole
# 10.100.0.0/16 fabric via the leaf, so replies to clients go back through the fabric.
# The node keeps its default route and its kind-network NIC for everything else.
# These changes are lost if the node container restarts; rerun this script then.
wire() {
    local node="$CLUSTER-$1" rack=$2 ip=$3 leaf=${3%.*}.2
    docker network connect --ip "$ip" "ia-$rack" "$node"
    docker exec "$node" ip route replace 10.100.0.0/16 via "$leaf"
}

wire worker  rack1 10.100.101.11
wire worker2 rack1 10.100.101.12
wire worker3 rack2 10.100.102.21
wire worker4 rack2 10.100.102.22

kubectl get nodes -L rack,ingress
