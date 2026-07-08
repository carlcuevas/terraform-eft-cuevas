# =============================================================================
# Variables raíz - Evaluación Final Transversal AUY1105
# =============================================================================

# -----------------------------------------------------------------------------
# General
# -----------------------------------------------------------------------------
variable "project_name" {
  description = "Nombre del proyecto. Se usa como prefijo en todos los recursos AWS"
  type        = string
  default     = "eft-cuevas"
}

variable "environment" {
  description = "Entorno de despliegue (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "El entorno debe ser uno de: dev, staging, prod."
  }
}

variable "aws_region" {
  description = "Región de AWS donde se desplegará la infraestructura"
  type        = string
  default     = "us-east-1"
}

# -----------------------------------------------------------------------------
# Networking
# -----------------------------------------------------------------------------
variable "vpc_cidr" {
  description = "Bloque CIDR de la VPC principal"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "Bloque CIDR de la subnet pública"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Zona de disponibilidad para la subnet pública"
  type        = string
  default     = "us-east-1a"
}

variable "ssh_allowed_cidr" {
  description = "CIDRs autorizados para acceso SSH. NO usar 0.0.0.0/0 (política OPA IL2.1)"
  type        = list(string)
  default     = ["10.0.0.0/8"]
}

# -----------------------------------------------------------------------------
# Compute
# -----------------------------------------------------------------------------
variable "ami_id" {
  description = "ID de la AMI para la instancia EC2 (Amazon Linux 2 en us-east-1)"
  type        = string
  default     = "ami-0c02fb55956c7d316"
}

variable "instance_type" {
  description = "Tipo de instancia EC2. Solo se permite t2.micro (política OPA IL2.1)"
  type        = string
  default     = "t2.micro"

  validation {
    condition     = var.instance_type == "t2.micro"
    error_message = "Solo se permite t2.micro según la política de seguridad OPA."
  }
}

variable "public_key" {
  description = "Clave pública SSH para acceso a la instancia EC2"
  type        = string
  sensitive   = true
}

variable "root_volume_size" {
  description = "Tamaño en GB del volumen raíz de la EC2"
  type        = number
  default     = 8
}

# -----------------------------------------------------------------------------
# Storage
# -----------------------------------------------------------------------------
variable "versioning_enabled" {
  description = "Habilitar versionado en el bucket S3"
  type        = bool
  default     = true
}
