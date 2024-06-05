#!/usr/bin/make

cluster:
	curl -sfL https://get.k3s.io | sh -s - --disable traefik --write-kubeconfig-mode 0644

cert:
	kubectl -n cert-manager get secrets dev-ca -o jsonpath='{.data.ca\.crt}' | base64 -d > ca.crt