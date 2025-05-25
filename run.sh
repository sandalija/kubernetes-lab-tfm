#!/bin/bash

###############################
# Terraform
###############################
cd terraform/
terraform init -backend-config remote-state.tfbackend
terraform apply

# Extract the IP address from Terraform output
new_ip=$(terraform output -raw bastion_ip)

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
# Note: This assumes HostName is on its own line under Host bastion
sed -i.bak -E "/Host bastion/,/Host / s/(HostName )[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/\1$new_ip/" "$ssh_config"

echo "Updated 'bastion' IP to $new_ip in $ssh_config"

###############################
# Ansible
###############################
cd ansible
ansible-playbook main.yaml -i inventory.yaml

