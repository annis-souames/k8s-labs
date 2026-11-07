# k8s-labs

Hands-on labs for the harder corners of Kubernetes: networking, service mesh and node tuning.
Each lab is self-contained and reproducible, so you can follow along on your own machine.

Everything runs on [kind](https://kind.sigs.k8s.io/) unless a lab says otherwise, and clusters
are managed with GitOps using [Flux](https://fluxcd.io/).

## Labs

| Lab | What you learn | Status |
|-----|----------------|--------|
| [ip-announce](ip-announce/) | MetalLB in L2 and BGP mode, `LoadBalancer` services on bare metal | Planned |
| istio | Sidecar and ambient mode, traffic management, mTLS | Planned |
| numa-scheduling | Topology, CPU and Memory Manager, hugepages | Planned |
| multus | Multiple network interfaces per pod | Planned |
| sriov | Virtual functions, device plugin, pod attachment | Planned |

Labs are independent. Do them in any order, though the table is roughly easiest first.

## How a lab works

1. Read the lab's `README.md`. It lists requirements and what you'll build.
2. Run `scripts/create.sh` to create the lab's kind cluster and bootstrap Flux.
3. Follow the steps and run `scripts/verify.sh` to check your work.
4. Run `scripts/cleanup.sh` to delete the cluster.

Some labs (SR-IOV, NUMA) need real hardware and won't run on kind. They say so up front.

## Getting started

Install the tools in [docs/prerequisites.md](docs/prerequisites.md), then pick a lab.

## Repository layout

```
.
├── <lab-name>/        # One self-contained directory per lab
│   ├── README.md      # The lab guide
│   ├── kind-config.yaml
│   ├── base/          # Shared manifests (when a lab has variants)
│   ├── flux/          # Flux entrypoint for the lab's cluster
│   └── scripts/       # create, verify, cleanup
├── docs/              # Prerequisites and shared notes
└── templates/lab/     # Skeleton for new labs
```

Contributing or using a coding agent? See [AGENTS.md](AGENTS.md).

## License

[MIT](LICENSE)
