## K8s Hello Mutating Webhook & Cert-Manager
A Kubernetes Mutating Admission Webhook example with cert-manager self-signer.

#### Deploy to K8s ('whfun' namespace)

Deploy cert-manager if necessary

```bash
requires [cert-manager](https://cert-manager.io/docs/installation/kubectl/#installing-with-regular-manifests)
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.9.1/cert-manager.yaml
```

#### Deploy to K8s

```bash
git clone git@github.com:sallyom/k8s-mutating-webhook.git && cd k8s-mutating-webhook
make k8s
```

#### Mutated Pod Example

```bash
kubectl apply -f https://raw.githubusercontent.com/sallyom/k8s-hello-mutating-webhook/main/testdeploy.yaml
kubectl exec <testpod-name> -n whfun -it -- sh -c "cat /etc/config/hello.txt"
# The output should be:
THIS IS K8S
```

We successfully mutated our pod spec and added an arbitary volume/file in there, yay !

#### Cleanup

Delete all k8s resources

```bash
make k8s-delete-all
```

#### Run tests

```bash
make test
```

Build,Push image

```bash
# define env vars for building image
# update deployment.yaml with image name if building
export CONTAINER_REPO=quay.io/my-user/my-repo
export CONTAINER_VERSION=x.y.z
```

```bash
make podman-build
make podman-push
```
* for this example you'll need to make the container repository public unless you'll be specifying ImagePullSecrets on the Pod

*Forked from https://github.com/didil/k8s-hello-mutating-webhook*
* updated to add cert-manager
* updated docker w/ podman
* updated api versions and container image
