# _Using minikube to setup dev environment locally_

### _Pre-require_
* Docker desktop

### _Setup minikube_
* Download and install minikube follow the instruction [here](https://minikube.sigs.k8s.io/docs/start/).
* Make Docker the default driver:
  ```bash
  minikube config set driver docker
  ```
* Start the minikube with the aws credential mounted:
  ```bash
  minikube start --mount --mount-string="/path/to/your/aws/credentials:/home/minikube/.aws"
  ```
* Kubernetes dashboard (optional):
  ```bash
  minikube addons enable metrics-server && \
  minikube dashboard --url
  ```

### _Setup kubectl_
* Download and install kubectl follow the instruction [here](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
* Verify that kubectl is already installed
  ```bash
  kubectl version --output=yaml 
  ```
* Set alias (optional):
  ```bash
  alias 'k=kubectl'
  ```
  Usage:
  ```bash
  k get all
  k apply -f kube-manifest.yaml
  ...
  ```

### _Start the deployment and service_
* Create or update kubernetes deployment and service
  ```bash
  # Note the image in the web-deployment.yaml has variable $TAG, export variable to system then use envsubst to substitution the variable.
  export TAG=static-fix
  envsubst < web-deployment.yaml | \
  kubectl apply -f donggiang-store-default-networkpolicy.yaml,celery-monitor-deployment.yaml,celery-monitor-service.yaml,redis-deployment.yaml,redis-service.yaml,env-configmap.yaml,web-service.yaml,-
  ```
* Debug:
  ```bash
  # Get all kubernetes things like pod, service, deployment, replicaset, etc.
  kubectl get all
  # Once you get the pod name that having status as error use describe to describe it
  kubectl describe pod <pod-name>
  # If the error is not coming from the kuber itself then use logs to get log from container
  # Use flag --follow to get the real-time log
  # Use flag -c | --container <container-name> if the pod is running multi container inside
  kubectl logs --follow <pod-name> -c <container-name>
  ```
* Access the minikube service
  ```bash
  minikube service <service-name> --url
  # Example
  minikube service web --url
  ```
* [Performing a Rolling Update:](https://kubernetes.io/docs/tutorials/kubernetes-basics/update/update-intro/)
  ```bash
  # Scale the deployment
  kubectl scale deployments/web --replicas=3
  # Update deployment image
  kubectl set image deployments/web web=donggiangthai/donggiang_store_local-web:static-fix-v1
  ```