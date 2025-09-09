output "public_ip" {
  description = "The public IP address of the web server"
  value       = aws_instance.web
}

output "instance" {
  description = "EC2 instance ID"
  value       = aws_instance.web.id

}