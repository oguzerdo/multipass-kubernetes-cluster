2.1 Connect to the master node via terminal.

```sh
make connect-master
```

2.2 Install `make`.
```sh
sudo apt install make
```

2.3 Clone the Git repository and navigate into the directory:

```sh
git clone https://github.com/oguzerdo/multipass-kubernetes-cluster.git
cd multipass-kubernetes-cluster
```

2.4 Inside the master terminal, run all the shell scripts.

```sh
make master-install
```

2.5 Copy the output of the join command for worker nodes. It will be something like:
    
```sh
kubeadm join 192.168.64.3:6443 --token al0kvi.x60mi1xj4zesqnq3 --discovery-token-ca-cert-hash sha256:f4ff0c7684bbac599a8208b94bb28e451023662ab51bc1ce16f60a855a85e2a5
```
