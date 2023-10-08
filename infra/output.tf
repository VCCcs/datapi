resource "local_file" "private_key" {
  content  = tls_private_key.key.private_key_pem
  filename = "test_key.pem"
}

output "public_ip" {
  value = aws_instance.api[*].public_ip
}

resource "local_file" "load_balancer_dns_name" {
  content  = aws_lb.front.dns_name
  filename = "api_dns_name.txt"
}