#!/usr/bin/make

cluster:
	curl -sfL https://get.k3s.io | sh -s - --disable traefik --write-kubeconfig-mode 0644

provision:
	terraform init
	terraform apply -auto-approve

cert:
	kubectl -n cert-manager get secrets dev-ca -o jsonpath='{.data.ca\.crt}' | base64 -d > ca.crt

hosts:
	@./scripts/hosts.sh add argo.kube 127.0.0.1
	@./scripts/hosts.sh add nginx.kube 127.0.0.1