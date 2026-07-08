# =============================================================================
# Outputs: módulo compute
# =============================================================================

output "instance_id" {
  description = "ID de la instancia EC2 creada"
  value       = aws_instance.main.id
}

output "instance_private_ip" {
  description = "IP privada de la instancia EC2"
  value       = aws_instance.main.private_ip
}

output "elastic_ip" {
  description = "IP pública elástica asociada a la instancia EC2"
  value       = aws_eip.main.public_ip
}

output "key_pair_name" {
  description = "Nombre del Key Pair creado"
  value       = aws_key_pair.main.key_name
}
