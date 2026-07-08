# =============================================================================
# Outputs: módulo networking
# =============================================================================

output "vpc_id" {
  description = "ID de la VPC creada"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "ID de la subnet pública creada"
  value       = aws_subnet.public.id
}

output "security_group_id" {
  description = "ID del Security Group creado"
  value       = aws_security_group.main.id
}

output "internet_gateway_id" {
  description = "ID del Internet Gateway creado"
  value       = aws_internet_gateway.main.id
}
