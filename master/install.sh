# # Append the machine's IP and hostname to /etc/hosts
sudo sh -c "echo $(hostname -i | xargs -n1 | grep ^10.) $(hostname) >> /etc/hosts"

# Write the specified values into /etc/sysctl.d/k8s.conf file
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

# Reload the sysctl settings from all system configuration files
sudo sysctl --system

# Update the apt package index and install packages needed to use the Kubernetes apt repository:
sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl gnupg

# Download the public signing key for the Kubernetes package repositories. 
# The same signing key is used for all repositories so you can disregard the version in the URL:
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring

# Add the appropriate Kubernetes apt repository. 
# If you want to use Kubernetes version different than v1.30, replace v1.30 with the desired minor version in the command below:

# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list   # helps tools such as command-not-found to work correctly

# Update apt package index to ensure the availability of the latest versions of packages
sudo apt-get update

# Install kubelet, kubeadm, and kubectl packages
sudo apt-get install -y kubelet kubeadm kubectl

# Mark kubelet, kubeadm, and kubectl packages to prevent automatic updates
sudo apt-mark hold kubelet kubeadm kubectl

# Reload systemd to reflect changes and restart kubelet service
sudo systemctl daemon-reload
sudo systemctl restart kubelet

sudo kubeadm init --pod-network-cidr=192.168.0.0/16

# To start using your cluster, you need to run the following as a regular user:
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install Pod network add-on (calico)
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/tigera-operator.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/custom-resources.yaml
