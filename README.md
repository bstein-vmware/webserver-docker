# webserver-docker

cd ~/Downloads
git clone https://github.com/bstein-vmware/webserver-docker.git
cd webserver-docker
podman build -t webserver-docker .
podman image ls #copy the IMAGE ID
podman tag [IMAGE_ID] harbor.site-a.vcf.lab/library/webserver-docker:latest
podman push harbor.site-a.vcf.lab/library/webserver-docker:latest
vcf context use vks-cluster-qxml:kubernetes-cluster-qxml
kubectl label --overwrite namespace default pod-security.kubernetes.io/enforce=privileged
kubectl run webserver-docker --image=harbor.site-a.vcf.lab/library/webserver-docker -n default