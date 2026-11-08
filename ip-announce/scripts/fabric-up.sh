#!/usr/bin/env bash
# Build the spine-leaf fabric: Docker networks as links, FRR containers as switches, one client.
set -euo pipefail
cd "$(dirname "$0")/.."
source scripts/env.sh

# One Docker network per link or segment. "s1l2" is the link spine1 <-> leaf2.
# Convention: spine = .2 and leaf = .3 on fabric links; leaf = .2 on its rack/border network.
while read -r name subnet; do
    docker network create --subnet "$subnet" "ia-$name" >/dev/null
done <<'NETS'
s1l1 10.100.11.0/24
s1l2 10.100.12.0/24
s1l3 10.100.13.0/24
s2l1 10.100.21.0/24
s2l2 10.100.22.0/24
s2l3 10.100.23.0/24
rack1 10.100.101.0/24
rack2 10.100.102.0/24
border 10.100.103.0/24
NETS

# router <name> <network:ip>...  The first network is the container's primary one.
router() {
    local name=$1; shift
    local first=$1; shift
    # ip_forward lets the container route. Hash policy 3 spreads ECMP flows by the 5-tuple.
    # Containers share one kernel and a flow keeps its hash from hop to hop, so with the stock
    # policy every tier picks the same next hop and some paths never get used (polarization).
    # A per-router seed makes each hop hash independently.
    local seed; seed=$(printf %s "$name" | cksum | cut -d' ' -f1)
    docker create --name "$name" --hostname "$name" --network "ia-${first%%:*}" --ip "${first##*:}" \
        --cap-add NET_ADMIN --cap-add NET_RAW --cap-add SYS_ADMIN \
        --sysctl net.ipv4.ip_forward=1 \
        --sysctl net.ipv4.fib_multipath_hash_policy=3 \
        --sysctl net.ipv4.fib_multipath_hash_fields=0x0037 \
        --sysctl net.ipv4.fib_multipath_hash_seed="$seed" \
        "$FRR_IMAGE" >/dev/null
    for link in "$@"; do
        docker network connect --ip "${link##*:}" "ia-${link%%:*}" "$name"
    done
    docker cp fabric/daemons "$name:/etc/frr/daemons"
    docker cp fabric/vtysh.conf "$name:/etc/frr/vtysh.conf"
    docker cp "fabric/$name/frr.conf" "$name:/etc/frr/frr.conf"
    docker start "$name" >/dev/null
}

router spine1 s1l1:10.100.11.2 s1l2:10.100.12.2 s1l3:10.100.13.2
router spine2 s2l1:10.100.21.2 s2l2:10.100.22.2 s2l3:10.100.23.2
router leaf1  s1l1:10.100.11.3 s2l1:10.100.21.3 rack1:10.100.101.2
router leaf2  s1l2:10.100.12.3 s2l2:10.100.22.3 rack2:10.100.102.2
router leaf3  s1l3:10.100.13.3 s2l3:10.100.23.3 border:10.100.103.2

# The "outside world": a host behind the border leaf that reaches the fabric via leaf3.
docker run -d --name client --network ia-border --ip 10.100.103.10 --cap-add NET_ADMIN \
    "$CLIENT_IMAGE" sleep infinity >/dev/null
docker exec client ip route add 10.100.0.0/16 via 10.100.103.2

echo "Fabric is up. Check sessions with: docker exec leaf1 vtysh -c 'show bgp summary'"
