# Prerequisites

Common tooling and cluster options shared by the labs. Each lab lists anything additional it needs.

## Tools

| Tool | Purpose |
|------|---------|
| `kubectl` | Interact with the cluster |
| `kind` | Create per-lab clusters |
| `flux` | Bootstrap and inspect GitOps |
| `helm` | Install charts (MetalLB, Istio, operators) |
| `git` | Clone this repo |
| `jq` / `yq` | Inspect JSON / YAML output |
| `istioctl` | Only for the Istio lab |

## Cluster options

| Option | Good for | Limitations |
|--------|----------|-------------|
| `kind` | MetalLB (L2), Istio, Multus basics | No real NUMA / SR-IOV; single host network |
| `minikube` / `k3s` | Quick single-node tests | Same hardware limits as above |
| `kubeadm` on VMs | MetalLB BGP, Multus, kubelet tuning | Needs a hypervisor and some setup |
| Bare metal | NUMA scheduling, SR-IOV | Requires suitable hardware (multi-socket CPU, SR-IOV capable NIC, IOMMU enabled) |

## Versions

Record the versions a lab was tested against at the top of that lab's README
(Kubernetes, CNI, Helm chart, OS/kernel where relevant).

## Troubleshooting

Add cross-lab notes and gotchas here as they come up.
