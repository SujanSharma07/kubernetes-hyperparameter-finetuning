#!/bin/bash
echo "Configuring Master Node"

# Install Docker:
echo "Installing Master Node..."
sudo apt-get update
sudo apt-get install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker

# Install Kubernetes Components
echo "Installing Kubernetes Components..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
kubectl version --client
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list   # helps tools such as command-not-found to work correctly
sudo apt-get update
sudo apt-get install -y kubectl kubeadm kubelet


# Disable Swap
echo "Disabling Swap..."
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

# For worker instance this much is enough
# Use below codes for master instance only

# Initialize the Kubernetes Cluster
echo "Initializing the Kubernetes Cluster..."
sudo kubeadm config images pull
sudo kubeadm init --pod-network-cidr=192.168.0.0/16 # The --pod-network-cidr=192.168.0.0/16 parameter specifies the IP range Kubernetes will use for assigning IPs to pods within the cluster.

# Set Up Kubectl
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install a Pod Network
echo "Installing a Pod Network..."
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml


# Join Command
# kubeadm token create --print-join-command
