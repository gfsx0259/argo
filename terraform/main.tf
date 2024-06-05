terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.30.0"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.13.2"
    }
  }
}

provider "kubernetes" {
  # uncomment if you use k3s distributive
  config_path = "/etc/rancher/k3s/k3s.yaml"
  config_context = "default"
  # uncomment if you use minikube
#   config_path    = "~/.kube/config"
#   config_context = "minikube"
}

provider "kubectl" {
  config_path = "/etc/rancher/k3s/k3s.yaml"
    config_context = "default"
}

provider "helm" {
  kubernetes {
    config_path = "/etc/rancher/k3s/k3s.yaml"
      config_context = "default"
  }
}

module "argocd" {
  source = "./argocd"
  depends_on = [
    module.certmanager,
    module.ingress,
  ]
}

module "certmanager" {
  source = "./certmanager"
}

module "ingress" {
  source = "./ingress"
}