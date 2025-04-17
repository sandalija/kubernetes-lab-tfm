# kubernetes-lab-tfm

## Run the cluser

### Create a key pair for your instance

````shell
ssh-keygen -t ed25519
````
This file should match with *private_key_path* and *public_key_path* in `terraform.tfvars`.

### Create the cluster using terraform

````shell
cd terraform/
terraform init -backend-config remote-state.tfbackend -upgrade
terraform init
terraform apply
````

Now, copy your public IP for your host instance to configure `.ss/config` file.

````
Host bastion
  HostName <PUBLIC_IP>
  User ec2-user
  IdentityFile <PRIVATE_KEY_PATH>

Host 10.0.*
  User ec2-user
  IdentityFile ~/.ssh/cluster.pem # set by the terraform code
  ProxyJump bastion
  StrictHostKeyChecking no
  UserKnownHostsFile=/dev/null
````

### Condfigure k3s using ansible

```shell
cd ../ansible
ansible-galaxy collection install git+https://github.com/k3s-io/k3s-ansible.git
```

Create a Ansible Vault to store the sync token

```shell
ansible-vault create k3s-vault.yaml
````

````
ansible-playbook k3s.orchestration.site -i inventory.yaml
ansible-playbook kubeconfig.yaml -i inventory.yaml
```

Now you can use the bastion and use kubectl or k9s

```shell
ssh bastion
kubectl get nodes 
k9s
````