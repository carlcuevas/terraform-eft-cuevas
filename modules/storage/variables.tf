# =============================================================================
# Variables: módulo storage
# =============================================================================

variable "project_name" {
  description = "Nombre del proyecto, usado como prefijo en el nombre del bucket"
  type        = string
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

variable "versioning_enabled" {
  description = "Habilitar versionado en el bucket S3"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Mapa de etiquetas aplicadas a todos los recursos del módulo"
  type        = map(string)
  default     = {}
}
