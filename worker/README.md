3.1 Connect to each worker node via terminal.
    
```sh
make connect-worker1
```

3.2 Install `make`.
```sh
sudo apt install make
```

3.3 Clone the Git repository and navigate into the directory:

```sh
git clone https://github.com/oguzerdo/multipass-kubernetes-cluster.git
cd multipass-kubernetes-cluster
```


3.4 For each worker node: Install necessary packages.
        
```sh
make worker-install
```

3.5 Run what you copied from Step 2, something like this,

```sh
kubeadm join 192.168.64.3:6443 --token al0kvi.x60mi1xj4zesqnq3     --discovery-token-ca-cert-hash sha256:f4ff0c7684bbac599a8208b94bb28e451023662ab51bc1ce16f60a855a85e2a5
```
