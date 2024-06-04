#!/usr/bin/make

start: cert

cert:
	minikube kubectl -- -n cert-manager get secrets dev-ca -o jsonpath='{.data.ca\.crt}' | base64 -d > ca.crt