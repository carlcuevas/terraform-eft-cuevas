# =============================================================================
# Outputs raíz - Evaluación Final Transversal AUY1105
# =============================================================================

# -----------------------------------------------------------------------------
# Networking
# -----------------------------------------------------------------------------
output "vpc_id" {
  description = "ID de la VPC desplegada"
  value       = module.networking.vpc_id
}

output "subnet_id" {
  description = "ID de la subnet pública"
  value       = module.networking.subnet_id
}

output "security_group_id" {
  description = "ID del Security Group"
  value       = module.networking.security_group_id
}

# -----------------------------------------------------------------------------
# Compute
# -----------------------------------------------------------------------------
output "instance_id" {
  description = "ID de la instancia EC2"
  value       = module.compute.instance_id
}

output "instance_public_ip" {
  description = "IP pública elástica de la instancia EC2"
  value       = module.compute.elastic_ip
}

output "instance_private_ip" {
  description = "IP privada de la instancia EC2"
  value       = module.compute.instance_private_ip
}

output "web_url" {
  description = "URL HTTP para acceder al servidor web desplegado en la EC2"
  value       = "http://${module.compute.elastic_ip}"
}

# -----------------------------------------------------------------------------
# Storage
# -----------------------------------------------------------------------------
output "bucket_id" {
  description = "Nombre del bucket S3"
  value       = module.storage.bucket_id
}

output "bucket_arn" {
  description = "ARN del bucket S3"
  value       = module.storage.bucket_arn
}

output "versioning_status" {
  description = "Estado del versionado del bucket S3"
  value       = module.storage.versioning_status
}
