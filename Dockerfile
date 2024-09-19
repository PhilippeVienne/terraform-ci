FROM docker.io/library/ubuntu:24.04

RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    jq \
    python3 \
    python3-pip \
    gnupg software-properties-common 

# Install HashiCorp tools
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list \
    && apt-get update && apt-get install -y \
    terraform \
    packer \
    vault \
    consul

# Install Scaleway CLI
RUN curl -s https://raw.githubusercontent.com/scaleway/scaleway-cli/master/scripts/get.sh

# Install AWS CLI
RUN pip3 install awscli --break-system-packages

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install Google Cloud SDK
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] \
    http://packages.cloud.google.com/apt cloud-sdk main" | \
    tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - \
    && apt-get update && apt-get install -y \
    google-cloud-sdk

# Install Kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl

# Install Helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 \
    && chmod 700 get_helm.sh \
    && ./get_helm.sh

# Install ArgoCD CLI
RUN CURRENT_ARCH=$(dpkg --print-architecture) \
    curl -sSL -o argocd-linux https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-${CURRENT_ARCH} \
    && install -m 555 argocd-linux /usr/local/bin/argocd \
    && rm argocd-linux

