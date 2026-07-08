# =============================================================================
# Módulo: storage
# -----------------------------------------------------------------------------
# Crea la infraestructura de almacenamiento:
#   - Bucket S3 con nombre único
#   - Configuración de acceso privado (Block Public Access)
#   - Versionado habilitado
#   - Cifrado del lado del servidor (SSE-S3)
#
# Indicadores evaluados: IL3.1, IL3.2, IL4.2
# =============================================================================

terraform {
  required_version = ">= 1.9.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_s3_bucket" "main" {
  bucket = "${var.project_name}-${var.environment}-bucket"

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-bucket"
  })
}

# Bloquear todo acceso público al bucket
resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Habilitar versionado para protección de datos
resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

# Cifrado del lado del servidor con SSE-S3
resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# Política de ciclo de vida para optimización de costos
resource "aws_s3_bucket_lifecycle_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    id     = "transicion-a-ia"
    status = "Enabled"

    filter {}

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}
