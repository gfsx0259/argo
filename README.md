# K3S Enthusiasts Cluster

Let`s setup lightweight Kubernetes cluster with minimal infrastructure set

## Prerequisites
* [Terraform](https://developer.hashicorp.com/terraform/install?product_intent=terraform#linux) needs to be installed, use can use snap package manager for easiest one command installation
```shell
sudo snap install terraform --classic
```

## Usage

1. Let`s setup k3s cluster as service using official script
```shell
make cluster
```
Let’s make sure the cluster is running and operational
```shell
kubectl get pods -A
```
Output should be similar to the following:
```text
NAMESPACE      NAME                                               READY   STATUS      RESTARTS      AGE
kube-system    local-path-provisioner-6c86858495-xcm9n            1/1     Running     0             10s
kube-system    coredns-6799fbcd5-s79b6                            1/1     Running     0             2s
kube-system    metrics-server-54fd9b65b-vgc9b                     1/1     Running     0             2s
```

2. Let`s provision our cluster with minimal infrastructure set
```shell
make provision
```

3. Let`s change /etc/hosts in order to direct traffic to cluster ingress
```shell
make hosts
```

4. Run next command to export authority certificate from cluster secrets to file `ca.crt`
```shell
make cert
```
Force the browser to trust this certificate. Go to `chrome://settings/certificates` and import it at **Certification Authority** tab.

5. Congratulations 🎈, our cluster is up and running. We installed a set of necessary infrastructure there. We also launched an example user application using [ARGO CD](https://argoproj.github.io/cd/) gitOps operator.
* https://argo.kube
* https://nginx.kube

To interact with your cluster use:
* `kubectl`
* [Lens IDE](https://k8slens.dev/), browse and open kube config file `/etc/rancher/k3s/k3s.yaml` to select your local cluster