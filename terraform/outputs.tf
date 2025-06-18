output "node_a_private_ip" {
  value = aws_instance.node_a.private_ip
}

output "node_b_private_ip" {
  value = aws_instance.node_b.private_ip
}
