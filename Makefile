# Makefile

# Node count to create
NODE_COUNT ?= 3

# Main target
deploy: create-master create-workers

# Create master node
create-master:
	multipass launch --name master -c 2 -m 2G -d 20G

# Create worker nodes
create-workers:
	$(eval N := $(NODE_COUNT))
	@for i in $$(seq 1 $(N)); do \
		multipass launch --name worker$$i -c 2 -m 2G -d 20G; \
	done

# Destroy target
destroy:
	multipass/destroy.sh

# Connect to master
connect-master:
	multipass shell master

# Connect to a specific worker
connect-worker%:
	multipass shell worker$(shell expr $(subst connect-worker,,$@))

# Install master components
master-install: master-containerd master-install

# Install worker components
worker-install: worker-containerd worker-install

# Install containerd on master
master-containerd:
	./master/containerd.sh

# Install helm chart on master
get-helm:
	./master/helm-chart.sh

# Install Kubernetes on master
master-install:
	./master/install.sh

# Install containerd on workers
worker-containerd:
	./worker/containerd.sh

# Install Kubernetes on workers
worker-install:
	./worker/install.sh