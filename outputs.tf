output "minikube_id" {
   value = ["${aws_instance.minikube.id}"]
}

output "minikube_ip" {
   value = ["${aws_instance.minikube.public_ip}"]
}