# Convenience Scripts for Deploying Galaxy on Kubernetes

## Prerequisites
- A working Kubernetes cluster
- Setting `/.kube/config`
- `kubectl` installed ([See Kubernetes docs](https://kubernetes.io/docs/tasks/tools/))
- `helm` installed ([SEe Helm docs](https://helm.sh/docs/intro/install/))

## Placeholder variables
In the examples below, I will be using a number of placeholder variables

```
export GXYDOMAIN=kubedev.usegalaxy.org # Domain at which to deploy galaxies
export MYBRANCH=my_branch # Branch on which I want to develop
export BASEBRANCH=upstream/dev # Base branch
export IMAGEREPO=galaxy/galaxy-min # Base image
export IMAGETAG=latest # latest == dev ;; 21.01 == release_21.01, etc... 
```
Note: In order for the code injection to work, the code on the image used needs to correspond to the base branch, in order for the list of changes generated by `git diff` to be accurate.

## Quick Start

### One-time setup

1. Clone the scripts repository:

```
git clone https://github.com/CloudVE/galaxy-k8s-dev-env
cd galaxy-k8s-dev-env
```

2. a) Using existing clones of `galaxy` and `galaxy-helm`
```
bash symlink_branch.sh $MYBRANCH /path/to/galaxy /path/to/galaxy-helm
```
NOTE: This will run `git checkout -b $MYBRANCH` in both repositories


2. b) Start with fresh clones of `galaxy` and `galaxy-helm`
```
bash setup_branch.sh $MYBRANCH
```

### Repeatable

3. Make changes to code in `galaxy` and `galaxy-helm` repositories. If you used `setuo_branch.sh`, you will find your clones under `galaxy-k8s-dev-env/branches/$MYBRANCH/galaxy[-helm]`.
If you symlinked existing repositories, you can continue to use them and make commits or keep changes uncommitted until you're ready to preview. You must have `$MYBRANCH` checked out before the next step.


4. Detect updates from the base branch.
```
bash update_links.sh $MYBRANCH $GXYDOMAIN /my-desired-path $BASEBRANCH
```
Note: This will detect changed files (currently supporting added and modified files), then will symlink them into `galaxy-helm/galaxy/extrafiles`. This enables deploying the newest code without rebuilding the image from scratch. It also creates a specific `values.yaml` and `extra-values.yaml` for this branch, the first deploying Galaxy at the desired domain and path, and the latter injecting the symlinked code as configmaps.


6. Deploy Galaxy
```
bash helm_update.sh $MYBRANCH desired-namespace --set image.repository=$IMAGEREPO --set image.tag=$IMAGETAG
```
