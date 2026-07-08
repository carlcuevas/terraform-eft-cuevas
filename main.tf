# =============================================================================
# Infraestructura como Código - Evaluación Final Transversal
# Asignatura: AUY1105 - Infraestructura como Código II
# Autor: Carlos Cuevas
# Versión: 1.0.0
# -----------------------------------------------------------------------------
# Este archivo orquesta los tres módulos principales de la solución:
#   - networking: VPC, Subnet, Internet Gateway, Route Table, Security Group
#   - compute:    EC2 t2.micro, Key Pair, Elastic IP
#   - storage:    S3 con cifrado, versionado y Block Public Access
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

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Course      = "AUY1105"
    }
  }
}

# =============================================================================
# Módulo: networking
# Crea VPC, Subnet pública, IGW, Route Table y Security Group
# =============================================================================
module "networking" {
  source = "./modules/networking"

  project_name      = var.project_name
  vpc_cidr          = var.vpc_cidr
  subnet_cidr       = var.subnet_cidr
  availability_zone = var.availability_zone
  ssh_allowed_cidr  = var.ssh_allowed_cidr

  tags = {
    Module = "networking"
  }
}

# =============================================================================
# Módulo: compute
# Crea instancia EC2 t2.micro, Key Pair y Elastic IP
# =============================================================================
module "compute" {
  source = "./modules/compute"

  project_name      = var.project_name
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  subnet_id         = module.networking.subnet_id
  security_group_id = module.networking.security_group_id
  public_key        = var.public_key
  root_volume_size  = var.root_volume_size

  tags = {
    Module = "compute"
  }

  depends_on = [module.networking]
}

# =============================================================================
# Módulo: storage
# Crea bucket S3 privado con cifrado, versionado y lifecycle
# =============================================================================
module "storage" {
  source = "./modules/storage"

  project_name       = var.project_name
  environment        = var.environment
  versioning_enabled = var.versioning_enabled

  tags = {
    Module = "storage"
  }
}
