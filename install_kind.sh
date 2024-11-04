#!/bin/bash
KIND_VERSION="v0.11.1"
wget "https://github.com/kubernetes-sigs/kind/releases/download/${KIND_VERSION}/kind-linux-amd64" -O kind
chmod +x kind
sudo mv kind /usr/local/bin/
kind version
