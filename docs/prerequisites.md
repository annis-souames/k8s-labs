# Prerequisites

Tools shared by all labs. A lab lists anything extra at the top of its `lab.md`.

## Tools

| Tool | Used for |
|------|----------|
| `docker` | Runs the kind nodes |
| `kind` | Creates local clusters |
| `kubectl` | Talks to the cluster |
| `flux` | Bootstraps and inspects GitOps |
| `helm` | Installs charts (MetalLB, Istio, operators) |
| `git` | Clones this repo |
| `jq`, `yq` | Reads JSON and YAML output |
| `istioctl` | Istio lab only |

Check what you have:

```bash
kind version && kubectl version --client && flux --version && helm version --short
```

## Flux needs a GitHub token

`flux bootstrap github` commits to your fork of this repo. Create a personal access token with
`repo` scope and export it:

```bash
export GITHUB_OWNER=<your-github-user>
export GITHUB_TOKEN=<token>
```

Fork the repo first and clone your fork. Never commit the token.

## Cluster options

| Option | Good for | Limits |
|--------|----------|--------|
| `kind` | MetalLB (L2), Istio, Multus basics | No real NUMA or SR-IOV; single host network |
| `minikube`, `k3s` | Quick single-node tests | Same hardware limits |
| `kubeadm` on VMs | MetalLB BGP, Multus, kubelet tuning | Needs a hypervisor |
| Bare metal | NUMA scheduling, SR-IOV | Needs a multi-socket CPU or an SR-IOV NIC, IOMMU on |

## Running several labs

Each lab creates its own cluster, and each one costs roughly 1-2 GB of RAM. Keep one or two up
at a time and clean up when you're done.

## Troubleshooting

Cross-lab gotchas go here as they come up.
