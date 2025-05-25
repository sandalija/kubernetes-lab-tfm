#### Requirements

No requirements.

#### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider_aws) | 5.94.1 |
| <a name="provider_http"></a> [http](#provider_http) | 3.4.5 |

#### Modules

No modules.

#### Resources

| Name | Type |
|------|------|
| [aws_eip.nat_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_instance.bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.control_plane](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.worker_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.worker_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_internet_gateway.gw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_key_pair.deployer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_nat_gateway.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.private_internet_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.ec2_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_ami.amazon_linux_2023](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [http_http.current_ip](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

#### Inputs

| Name | Description | Type |
|------|-------------|------|
| <a name="input_aws_availability_zone"></a> [aws_availability_zone](#input_aws_availability_zone) | AWS Availability zone | `string` |
| <a name="input_flatcar_ami"></a> [flatcar_ami](#input_flatcar_ami) | AMI for FlatCar in your region | `string` |
| <a name="input_private_key_path"></a> [private_key_path](#input_private_key_path) | Path to file with public key | `string` |
| <a name="input_public_key_path"></a> [public_key_path](#input_public_key_path) | Path to file with public key | `string` |
| <a name="input_ec2_user"></a> [ec2_user](#input_ec2_user) | n/a | `string` |
| <a name="input_public_worker_1"></a> [public_worker_1](#input_public_worker_1) | Set as true to configure Worker 1 as public | `bool` |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion"></a> [bastion](#output_bastion) | n/a |
| <a name="output_bastion_ip"></a> [bastion_ip](#output_bastion_ip) | n/a |
| <a name="output_control_plane"></a> [control_plane](#output_control_plane) | n/a |
| <a name="output_worker_1"></a> [worker_1](#output_worker_1) | n/a |
| <a name="output_worker_2"></a> [worker_2](#output_worker_2) | n/a |
