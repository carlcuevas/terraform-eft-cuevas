# =============================================================================
# Configuración TFLint - Evaluación Final Transversal AUY1105
# -----------------------------------------------------------------------------
# TFLint analiza el código Terraform en busca de:
#   - Errores de configuración específicos del proveedor AWS
#   - Desviaciones de las mejores prácticas
#   - Variables no declaradas y tipos incorrectos
#
# Indicador evaluado: IL1.2
# =============================================================================

plugin "aws" {
  enabled = true
  version = "0.32.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

# -----------------------------------------------------------------------------
# Reglas de mejores prácticas generales
# -----------------------------------------------------------------------------

# Asegurar que todas las variables tengan descripción
rule "terraform_documented_variables" {
  enabled = true
}

# Asegurar que todos los outputs tengan descripción
rule "terraform_documented_outputs" {
  enabled = true
}

# Verificar que los módulos usen fuentes con versiones fijas
rule "terraform_module_pinned_source" {
  enabled = true
  style   = "flexible"
}

# Requerir declaración explícita de versión del proveedor
rule "terraform_required_providers" {
  enabled = true
}

# Requerir versión mínima de Terraform
rule "terraform_required_version" {
  enabled = true
}

# Convención de nombres para recursos (snake_case)
rule "terraform_naming_convention" {
  enabled = true

  variable {
    format = "snake_case"
  }

  output {
    format = "snake_case"
  }

  resource {
    format = "snake_case"
  }
}

# Detectar variables no utilizadas
rule "terraform_unused_declarations" {
  enabled = true
}

# Detectar llamadas a data sources no utilizados
rule "terraform_unused_required_providers" {
  enabled = true
}

# -----------------------------------------------------------------------------
# Reglas específicas de AWS
# -----------------------------------------------------------------------------

# Validar que los tipos de instancia EC2 sean válidos en AWS
rule "aws_instance_invalid_type" {
  enabled = true
}

# Validar que las AMI existan y sean válidas
rule "aws_instance_invalid_ami" {
  enabled = false # Se deshabilita porque requiere credenciales AWS en lint
}

# Validar tipos de volumen EBS
rule "aws_db_instance_invalid_type" {
  enabled = true
}
