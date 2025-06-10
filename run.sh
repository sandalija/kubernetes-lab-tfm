#!/bin/bash

###############################
# Terraform
###############################
echo "cd terraform/"
cd terraform/

echo "terraform init -backend-config remote-state.tfbackend"
terraform init -backend-config remote-state.tfbackend

echo "terraform apply"
terraform apply

# Extract the IP address from Terraform output
echo "new_ip=\$(terraform output -raw bastion_ip)"
new_ip=$(terraform output -raw bastion_ip)

echo "cd -"
cd -

###############################
# Edit ~/.ssh/config
###############################
if [[ ! $new_ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Error: Could not extract a valid IP address from terraform output."
  exit 1
fi

# Update the .ssh/config file
ssh_config="$HOME/.ssh/config"

if ! grep -q "Host bastion" "$ssh_config"; then
  echo "Error: 'Host bastion' not found in $ssh_config"
  exit 1
fi

# Use sed to replace the HostName line under 'Host bastion'
echo "sed -i.bak -E \"/Host bastion/,/Host / s/(HostName )[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/\\1\$new_ip/\" \"\$ssh_config\""
sed -i.bak -E "/Host bastion/,/Host / s/(HostName )[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/\1$new_ip/" "$ssh_config"

echo "Updated 'bastion' IP to $new_ip in $ssh_config"

###############################
# Ansible
###############################
echo "cd ansible"
cd ansible

if [ ! -d ".venv" ]; then
  echo "python3 -m venv .venv"
  python3 -m venv .venv
fi

echo "source .venv/bin/activate"
source .venv/bin/activate

echo "pip install -r requirements.txt"
pip install -r requirements.txt

echo "ansible-galaxy collection install -r requirements.yaml"
ansible-galaxy collection install -r requirements.yaml

echo "ansible-playbook main.yaml"
ansible-playbook main.yaml

echo "ssh bastion"
ssh bastion
