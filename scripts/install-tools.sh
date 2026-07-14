#!/bin/bash

set -e

echo "======================================"
echo "Updating system packages..."
echo "======================================"
sudo apt update

echo "======================================"
echo "Installing Git..."
echo "======================================"
sudo apt install -y git

echo "======================================"
echo "Installing Docker..."
echo "======================================"
curl -fsSL https://get.docker.com | sudo sh

sudo usermod -aG docker $USER

echo "======================================"
echo "Installing Kind..."
echo "======================================"
curl -Lo kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64
chmod +x kind
sudo mv kind /usr/local/bin/

echo "======================================"
echo "Installing kubectl..."
echo "======================================"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

echo "======================================"
echo "Installing Helm..."
echo "======================================"
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "======================================"
echo "Installation Complete!"
echo "======================================"

echo "Versions:"
git --version
docker --version
docker compose version
kind version
kubectl version --client
helm version

echo
echo "IMPORTANT:"
echo "Log out and log back in (or reconnect via SSH)"
echo "before running Docker commands."
