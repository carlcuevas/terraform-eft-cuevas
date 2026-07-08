# =============================================================================
# Variables: módulo compute
# =============================================================================

variable "project_name" {
  description = "Nombre del proyecto, usado como prefijo en todos los recursos"
  type        = string
}

variable "ami_id" {
  description = "ID de la AMI para la instancia EC2 (Amazon Linux 2)"
  type        = string
  default     = "ami-0c02fb55956c7d316" # Amazon Linux 2 us-east-1
}

variable "instance_type" {
  description = "Tipo de instancia EC2. Solo se permite t2.micro (política OPA IL2.1)"
  type        = string
  default     = "t2.micro"

  validation {
    condition     = var.instance_type == "t2.micro"
    error_message = "Solo se permite el tipo de instancia t2.micro según la política de seguridad."
  }
}

variable "subnet_id" {
  description = "ID de la subnet donde se desplegará la instancia EC2"
  type        = string
}

variable "security_group_id" {
  description = "ID del Security Group a asociar con la instancia EC2"
  type        = string
}

variable "public_key" {
  description = "Clave pública SSH para el Key Pair de acceso a la instancia"
  type        = string
  sensitive   = true
}

variable "root_volume_size" {
  description = "Tamaño en GB del volumen raíz de la instancia EC2"
  type        = number
  default     = 8

  validation {
    condition     = var.root_volume_size >= 8 && var.root_volume_size <= 100
    error_message = "El tamaño del volumen debe estar entre 8 y 100 GB."
  }
}

variable "tags" {
  description = "Mapa de etiquetas aplicadas a todos los recursos del módulo"
  type        = map(string)
  default     = {}
}
