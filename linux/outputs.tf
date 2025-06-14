output "ip" {
    description = "Public IP address of Linux instance"
    value       = aws_instance.ubuntu.public_ip
}