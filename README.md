## K8s Hello Mutating Webhook & Cert-Manager
A Kubernetes Mutating Admission Webhook example with cert-manager self-signer.

#### Deploy to K8s ('whfun' namespace)

```
$ kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.5.3/cert-manager.yaml
$ make k8s
```

#### Mutated Pod Example

```
$ kubectl run busybox-1 -n whfun --image=busybox  --restart=Never -l=hello=true -- sleep 3600
$ kubectl exec busybox-1 -n whfun -it -- ls /etc/config/hello.txt
# The output should be:
/etc/config/hello.txt

$ kubectl exec busybox-1 -n whfun -it -- sh -c "cat /etc/config/hello.txt"
# The output should be:
THIS IS K8S
```

We successfully mutated our pod spec and added an arbitary volume/file in there, yay !
Try it with the deployment, too! `kubectl apply -f testdeploy.yaml` then check the pods for hello.txt.

#### Cleanup

Delete all k8s resources

```
$ make k8s-delete-all
```

#### Run tests

```
$ make test
```

Build,Push image

```
# define env vars for building image
# update deployment.yaml with image name if building
$ export CONTAINER_REPO=quay.io/my-user/my-repo
$ export CONTAINER_VERSION=x.y.z
```

```
$ make podman-build
$ make podman-push
```
* for this example you'll need to make the container repository public unless you'll be specifying ImagePullSecrets on the Pod

*Forked from https://github.com/didil/k8s-hello-mutating-webhook*
* updated to add cert-manager
* updated docker w/ podman
* updated api versions and container image
