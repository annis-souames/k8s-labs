# k8s-labs

Hands-on labs for the harder corners of Kubernetes: networking, service mesh and node tuning.
Each lab is self-contained and reproducible, so you can follow along on your own machine.

Everything runs on [kind](https://kind.sigs.k8s.io/) unless a lab says otherwise, and clusters
are managed with GitOps using [Flux](https://fluxcd.io/).

## Labs

| Lab | What you learn | Status |
|-----|----------------|--------|
| [ip-announce](ip-announce/lab.md) | MetalLB over BGP with an FRR spine-leaf fabric, Istio ingress gateway, Flux | In progress |
| istio | Sidecar and ambient mode, traffic management, mTLS | Planned |
| numa-scheduling | Topology, CPU and Memory Manager, hugepages | Planned |
| multus | Multiple network interfaces per pod | Planned |
| sriov | Virtual functions, device plugin, pod attachment | Planned |

Labs are independent. Do them in any order, though the table is roughly easiest first.

## How a lab works

1. Read the lab's `lab.md`. It lists requirements and what you'll build.
2. Follow the steps. They call the helper scripts in the lab's `scripts/`.
3. Check your work with `scripts/verify.sh` where a lab has one.
4. Clean up with `scripts/cleanup.sh`.

Some labs (SR-IOV, NUMA) need real hardware and won't run on kind. They say so up front.

## Getting started

Install the tools in [docs/prerequisites.md](docs/prerequisites.md), then pick a lab.

## Repository layout

```
.
├── <lab-name>/        # One self-contained directory per lab
│   ├── lab.md         # The lab guide
│   ├── kind-config.yaml
│   ├── manifests/     # What Flux deploys into the cluster
│   ├── flux/          # Flux entrypoint for the lab's cluster
│   └── scripts/       # Setup, verify and cleanup helpers
├── docs/              # Prerequisites and shared notes
└── templates/lab/     # Skeleton for new labs
```

Contributing or using a coding agent? See [AGENTS.md](AGENTS.md).

## License

[MIT](LICENSE)
