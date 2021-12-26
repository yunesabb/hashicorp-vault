#!/usr/bin/make -f

SHELL := /bin/bash

.PHONY: deploy-vault

deploy-vault:
	@echo -e "Starting Kubernetes Vault and Traefik deployment" ;\
	echo -e "[i] Generating diffs... This might take a while. Please wait and do NOT press any key.\n" ; \
	kustomize build . | kubectl diff -f - ; \
	if [ $$? -eq 1 ]; then \
		echo -e "\n[i] Ready to update, are you sure? Ctrl+C to cancel " && read ans ;\
		kustomize build . | kubectl apply -f - ;\
	else \
		echo "[i] No diffs found"; \
	fi

.PHONY: configure-vault

configure-vault:
	@echo -e "Starting Kubernetes Vault initialization and configuration" ;\
	./vault/configure.sh


