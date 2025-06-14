output "ip" {
    description = "Public IP address of Linux instance"
    value       = aws_instance.ubuntu.public_ip
}

output "instance_id" {
    description = "Instance ID of Linux instance"
    value       = aws_instance.ubuntu.id
}