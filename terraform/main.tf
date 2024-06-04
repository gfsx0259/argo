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
  # config_path = "/etc/rancher/k3s/k3s.yaml"
  # config_context = "default"
  config_path    = "/home/jeny/.kube/config"
  config_context = "minikube"
}

provider "kubectl" {
  config_path    = "/home/jeny/.kube/config"
  config_context = "minikube"
}

provider "helm" {
  kubernetes {
        config_path = "/home/jeny/.kube/config"
        config_context = "minikube"
    }
}

module "argocd" {
  source = "./argocd"
  depends_on = [module.certmanager]
}

module "certmanager" {
  source = "./certmanager"
}