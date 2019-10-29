# Some scripts for CentOS7


// Update and upgrade system.

$wget https://raw.githubusercontent.com/icobra/cent_scripts/master/update.sh
$chmod a+x update.sh
$./update.sh

/*
After restart server.
Test kernel > 5.1.
$uname -a

Now available ifconfig, mc, nano. 
*/

#Change behaviour for bridge-nf-call-iptables to 1
# Add on /etc/sysctl.conf
# net.bridge.bridge-nf-call-iptables = 1

$sysctl -p

# Install Docker CE.

$wget https://raw.githubusercontent.com/icobra/cent_scripts/master/factory_docker.sh
$chmod a+x factory_docker.sh
$./ factory_docker.sh 

/*

# Wait some time to start docker, after check his works.
$docker version
$docker ps

# Check firewall status - it must be off.
$systemctl status firewalld

#Check net-bridge. We must see 1.

$cd /proc/sys/net/bridge
$cat bridge-nf-call-iptables

*/

# Install Kubernetes.
$wget https://raw.githubusercontent.com/icobra/cent_scripts/master/factory_kubernetes.sh
$chmod a+x factory_kubernetes.sh
$./factory_kubernetes.sh

# We will use Calico.
kubeadm init --pod-network-cidr=192.168.0.0/16  --apiserver-advertise-address=185.244.42.6 --ignore-preflight-errors=all

/*
--pod-network-cidr необходим драйверу Calico и определяет адресное пространство для контейнеров.
--apiserver-advertise-address определяет IP-адрес, который Kubernetes будет афишировать в качестве своего API-сервера.
*/

## Add new user for kubernetes.
$useradd nickname -G wheel -m -s /bin/bash
$passwd nickname

$sudo su nickname

$cd $HOME
$sudo whoami

$sudo cp /etc/kubernetes/admin.conf $HOME/
$sudo chown $(id -u):$(id -g) $HOME/admin.conf
$export KUBECONFIG=$HOME/admin.conf
$echo "export KUBECONFIG=$HOME/admin.conf" | tee -a ~/.bashrc

##  install the CNI. For Calico run. (We will apply the network configuration to the cluster).

$kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml
$kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml

## To enable it on a single-node cluster.
$kubectl taint nodes --all node-role.kubernetes.io/master-

// See info aboute claster. kubectl get all --namespace=kube-system

## install Nginx Ingress-Controller.

$kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml

/* Create Ingress-controller

(change %EXTERNAL IP% to the machine’s external ip address):

file -> ingress-controller.yaml
apiVersion: v1
kind: Service
metadata:
  name: ingress-nginx
  namespace: ingress-nginx
spec:
  ports:
  - name: http
    port: 80
    targetPort: 80
    protocol: TCP
  - name: https
    port: 443
    targetPort: 443
    protocol: TCP
  selector:
    app.kubernetes.io/name: ingress-nginx
  externalIPs:
  - %EXTERNAL IP%

*/

$kubectl run wordpress --image=tutum/wordpress -port 80

/*
file --> ingress.yaml

apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: test-ingress
spec:
  backend:
    serviceName: wordpress
    servicePort: 80
*/
