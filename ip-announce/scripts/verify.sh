#!/usr/bin/env bash
# Check the lab end to end: BGP sessions, the announced address, and a request from the client.
# Needs jq on the host. Exits non-zero on the first failure.
set -euo pipefail

VIP=10.100.200.10
ok()   { echo "ok    $*"; }
fail() { echo "FAIL  $*"; exit 1; }

for router in spine1 spine2 leaf1 leaf2 leaf3; do
    read -r total down < <(docker exec "$router" vtysh -c 'show bgp summary json' |
        jq -r '.ipv4Unicast.peers | [length, ([.[] | select(.state != "Established")] | length)] | @tsv')
    [ "$down" = 0 ] || fail "$router: $down of $total BGP sessions are not established"
    ok "$router: $total BGP sessions established"
done

for leaf in leaf1 leaf2; do
    hops=$(docker exec "$leaf" vtysh -c "show ip route $VIP/32 json" |
        jq -r ".\"$VIP/32\"[0].nexthops[]?.ip" | paste -sd' ')
    [ -n "$hops" ] && ok "$leaf routes $VIP via: $hops" || ok "$leaf has no local route to $VIP (no node in its rack announces it)"
done

paths=$(docker exec leaf3 vtysh -c "show ip route $VIP/32 json" | jq ".\"$VIP/32\"[0].nexthops | length")
[ "${paths:-0}" -ge 1 ] || fail "leaf3 has no route to $VIP"
ok "leaf3 reaches $VIP over $paths spine path(s)"

body=$(docker exec client curl -fsS --max-time 5 "http://$VIP/ip") || fail "client cannot reach http://$VIP/ip"
ok "client got: $body"
