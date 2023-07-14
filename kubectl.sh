#!/bin/bash

#THIS SCRIPT WILL INSTALL KUBECTL IF YOU DON'T HAVE IT ALREADY (FROM KUBERNETES WEBSITE)

#1. Download latest release with the command:

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"



#2. Validate the binary (optional)

#Download the kubectl checksum file:
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"


#Validate the kubectl binary against the checksum file:
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check


#3. Install kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

#c. Apply execute permissions to the binary.

chmod +x ./kubectl


#d. If you do not have root access on the target system, you can still install kubectl to the ~/.local/bin directory:

#chmod +x kubectl
#mkdir -p ~/.local/bin
#mv ./kubectl ~/.local/bin/kubectl
# and then append (or prepend) ~/.local/bin to $PATH

#Test to ensure the version you installed is up-to-date:
kubectl version --client
