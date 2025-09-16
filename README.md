# webserver-docker

cd ~/Downloads
git clone https://github.com/bstein-vmware/webserver-docker.git
cd webserver-docker
podman build -t webserver-docker .
podman image ls #copy the IMAGE ID
podman tag [IMAGE_ID] harbor.site-a.vcf.lab/library/webserver-docker:v1
podman push harbor.site-a.vcf.lab/library/webserver-docker:v1
vcf context use vks-cluster-qxml:kubernetes-cluster-qxml
kubectl label --overwrite namespace default pod-security.kubernetes.io/enforce=privileged
kubectl run webserver-docker-1 --image=harbor.site-a.vcf.lab/library/webserver-docker:v1 -n default -l app=webserver-docker
# edit index.html to change the color
podman build -t webserver-docker .
podman iamge ls 
podman image ls #copy the IMAGE ID
podman tag [IMAGE_ID] harbor.site-a.vcf.lab/library/webserver-docker:v2
podman push harbor.site-a.vcf.lab/library/webserver-docker:v2
kubectl run webserver-docker-2 --image=harbor.site-a.vcf.lab/library/webserver-docker:v2 -n default -l app=webserver-docker


# loop to show load balancing across pods
while true; do curl 10.1.0.12 | grep color; sleep 1; done