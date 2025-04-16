output "bastion" {
  value = "Bastion -> Public IP ${aws_instance.bastion.public_ip}, Private IP ${aws_instance.bastion.private_ip}"
}

output "control_plane" {
  value = "Control Plane -> Private IP ${aws_instance.control_plane.private_ip}"
}

output "worker_1" {
  value = "Worker 1 -> Private IP ${aws_instance.worker_1.private_ip}"
}

output "worker_2" {
  value = "Worker 1 -> Private IP ${aws_instance.worker_2.private_ip}"
}