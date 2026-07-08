# =============================================================================
# Variables: módulo networking
# =============================================================================

variable "project_name" {
  description = "Nombre del proyecto, usado como prefijo en todos los recursos"
  type        = string
}

variable "vpc_cidr" {
  description = "Bloque CIDR para la VPC principal"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "El valor de vpc_cidr debe ser un bloque CIDR válido."
  }
}

variable "subnet_cidr" {
  description = "Bloque CIDR para la subnet pública"
  type        = string
  default     = "10.0.1.0/24"

  validation {
    condition     = can(cidrnetmask(var.subnet_cidr))
    error_message = "El valor de subnet_cidr debe ser un bloque CIDR válido."
  }
}

variable "availability_zone" {
  description = "Zona de disponibilidad donde se desplegará la subnet"
  type        = string
  default     = "us-east-1a"
}

variable "ssh_allowed_cidr" {
  description = "Lista de CIDRs autorizados para acceso SSH (NO usar 0.0.0.0/0)"
  type        = list(string)
  default     = ["10.0.0.0/8"]

  validation {
    condition     = !contains(var.ssh_allowed_cidr, "0.0.0.0/0")
    error_message = "SSH no puede estar abierto a 0.0.0.0/0. Especifica un CIDR restringido."
  }
}

variable "tags" {
  description = "Mapa de etiquetas aplicadas a todos los recursos del módulo"
  type        = map(string)
  default     = {}
}
