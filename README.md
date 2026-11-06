# k8s-labs

Hands-on labs to learn the more advanced corners of Kubernetes: networking, service mesh,
and performance-oriented node tuning. New labs are added roughly every weekend.

Each lab is self-contained: it has a goal, a reproducible setup, step-by-step instructions,
verification steps, and a cleanup section.

## Labs

| #  | Lab | Topics | Status |
|----|-----|--------|--------|
| 01 | IP announcement with MetalLB | L2 / BGP mode, `IPAddressPool`, `LoadBalancer` services on bare metal | Planned |
| 02 | Istio service mesh | Sidecar / ambient mode, traffic management, mTLS, observability | Planned |
| 03 | NUMA-aware scheduling | Topology Manager, CPU Manager, Memory Manager, hugepages | Planned |
| 04 | Multus CNI | Multiple network interfaces per pod, `NetworkAttachmentDefinition` | Planned |
| 05 | SR-IOV CNI | Virtual functions, SR-IOV device plugin, pod attachment | Planned |

More to come. Status values: `Planned` -> `In progress` -> `Done`.

## Repository layout

```
.
├── README.md
├── LICENSE
├── docs/                 # Shared documentation (prerequisites, cluster setup, troubleshooting)
├── labs/                 # One directory per lab, named NN-short-name
│   └── NN-short-name/
│       ├── README.md     # The lab guide
│       ├── manifests/    # Kubernetes YAML used by the lab
│       └── scripts/      # Helper scripts (setup, verify, cleanup)
└── templates/
    └── lab/              # Skeleton to copy when starting a new lab
```

## Starting a new lab

```bash
cp -r templates/lab labs/NN-short-name
$EDITOR labs/NN-short-name/README.md
```

Then add the lab to the table above.

## Prerequisites

See [docs/prerequisites.md](docs/prerequisites.md) for the common tooling and cluster options.
Individual labs list any extra requirements (specific hardware, NICs, kernel features) at the top
of their own README.

> Some labs (SR-IOV, NUMA) need real or specially configured hardware, or nested
> virtualization, and may not run on a laptop `kind` cluster. Each lab states what it needs.

## Conventions

- Labs are numbered in the order they were written, not by difficulty.
- Pin versions (Kubernetes, Helm charts, container images) so labs stay reproducible.
- Every lab ends with a cleanup section that returns the cluster to a clean state.
- No secrets or kubeconfigs in the repo (see `.gitignore`).

## License

[MIT](LICENSE)
