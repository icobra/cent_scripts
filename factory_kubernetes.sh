# Install Kubernetes
## Add Kubernetes repository

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

## Install kubectl
yum install -y kubectl

## Install kubelet, kubeadm, kubernetes-cni
yum update
yum install -y kubelet, kubeadm, kubernetes-cni
