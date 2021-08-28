# If modifying this ns, must substitute whfun/new-ns in
# ./k8s-webhook/webhookconf-cert-manage.yaml & ./k8s-deployment/deployment.yaml
NAMESPACE?=whfun
CONTAINER_REPO?=quay.io/sallyom/mutating-webhook
CONTAINER_VERSION?=test
CONTAINER_IMAGE=$(CONTAINER_REPO):$(CONTAINER_VERSION)

.PHONY: podman-build
podman-build:
	podman build -t $(CONTAINER_IMAGE) webhook

.PHONY: podman-push
podman-push:
	podman push $(CONTAINER_IMAGE) 

.PHONY: k8s
k8s: k8s-webhook k8s-deployment

.PHONY: k8s-webhook
k8s-webhook:
	kustomize build k8s-webhook | kubectl apply -f -

.PHONY: k8s-deployment
k8s-deployment:
	kubectl apply -f k8s-deployment/deployment.yaml

.PHONY: k8s-delete-all
k8s-delete-all:
	kustomize build k8s-webhook | kubectl delete --ignore-not-found=true -f  - 
	kubectl delete --ignore-not-found=true deployment/hello-webhook-deployment -n $(NAMESPACE)
	kubectl delete --ignore-not-found=true secret hello-webhook -n $(NAMESPACE)
	kubectl delete --ignore-not-found=true ns $(NAMESPACE)

.PHONY: test
test:
	cd webhook && go test ./...
