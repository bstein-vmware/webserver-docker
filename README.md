# webserver-docker
### Build the container and test locally
>cd ~/Downloads
git clone https://github.com/bstein-vmware/webserver-docker.git
cd webserver-docker
podman build -t webserver-docker .
podman run -d -p 8080:80 webserver-docker
podman ps -a #copy the NAME or CONTAINER ID
podman exec -it [NAME] /bin/sh # execute a shell in the running container to poke around
podman stop [NAME] && podman rm [NAME]


### Push container to repo (Harbor) and run on VKS
>podman image ls #copy the IMAGE_ID
podman tag [IMAGE_ID] harbor.site-a.vcf.lab/library/webserver-docker:v1
podman push harbor.site-a.vcf.lab/library/webserver-docker:v1
vcf context use vks-cluster-qxml:kubernetes-cluster-qxml
kubectl label --overwrite namespace default pod-security.kubernetes.io/enforce=privileged
kubectl run webserver-docker-1 --image=harbor.site-a.vcf.lab/library/webserver-docker:v1 -n default --label app=webserver-docker --dry-run=server -o yaml > webserver-docker.yaml
vim webserver-docker-pod.yaml #Insepct the yaml to see the image definition
kubectl apply -f webserver-docker-pod.yaml
kubectl expose pod webserver-docker --type=LoadBalancer --port=80 --label app=webserver-docker --dry-run=server -o yaml webserver-docker-svc.yaml

### Release a new chagne to the app and expose it with a Load Balancer service
* First, edit index.html to change the color and simulate a feature change
>podman build -t webserver-docker .
podman image ls 
podman image ls #copy the IMAGE ID
podman tag [IMAGE_ID] harbor.site-a.vcf.lab/library/webserver-docker:v2
podman push harbor.site-a.vcf.lab/library/webserver-docker:v2
kubectl run webserver-docker-2 --image=harbor.site-a.vcf.lab/library/webserver-docker:v2 -n default --label app=webserver-docker
* Now we have two versions of the app running behind the load balancer

### loop to show load balancing across pods
> while true;
  do curl 10.1.0.12 | grep color;
  sleep 1;
done

### Delete the individual pods and recreate them as a Deployment with two Replicas
>kubectl delete pod --label webserver-docker
kubectl delete svc webserver-docker
kubectl create deploy webserver-docker --image=harbor.site-a.vcf.lab/library/webserver-docker:v2 -n default --label app=webserver-docker --replicas=2
kubectl expose deploy webserver-docker --type=LoadBalancer --port=80