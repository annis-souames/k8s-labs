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

Each lab is a self-contained directory at the repo root. Cluster definition, Flux manifests,
simulated external components and scripts all live inside it, so deleting the folder removes the lab.

```
.
├── README.md
├── LICENSE
├── docs/                 # Shared documentation (prerequisites, cluster setup, troubleshooting)
├── templates/lab/        # Skeleton to copy when starting a new lab
└── <lab-name>/           # One directory per lab, e.g. ip-announce/
    ├── README.md         # The lab guide
    ├── kind-config.yaml  # Cluster definition (or one per variant, see below)
    ├── base/             # Manifests shared between variants (HelmRelease, ...)
    ├── flux/             # Flux entrypoint: bootstrap --path points here
    └── scripts/          # create.sh, verify.sh, cleanup.sh
```

Labs with variants (e.g. MetalLB L2 vs BGP) put `kind-config.yaml` and `flux/` in one
subdirectory per variant (`<lab-name>/l2/`, `<lab-name>/bgp/`) and share `base/`.

## GitOps with Flux

Every lab gets its own kind cluster, named `<lab-name>[-<variant>]`, and its own Flux
bootstrap pointed at `<lab-name>[/<variant>]/flux`. Enabling a lab is committing its manifests;
cleaning up is `scripts/cleanup.sh`. Things Flux cannot manage (simulated BGP routers, host
networking) are set up by the lab's scripts. Secrets are never committed (use SOPS + age if needed).

## Starting a new lab

```bash
cp -r templates/lab <lab-name>
$EDITOR <lab-name>/README.md
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
