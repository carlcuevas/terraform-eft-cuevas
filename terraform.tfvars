# =============================================================================
# Valores de variables - Evaluación Final Transversal AUY1105
# -----------------------------------------------------------------------------
# IMPORTANTE: No subir este archivo con credenciales reales a GitHub.
#             La variable public_key debe setearse como secret en CI/CD
#             o pasarse con -var en la línea de comandos.
# =============================================================================

project_name      = "eft-cuevas"
environment       = "dev"
aws_region        = "us-east-1"

# Networking
vpc_cidr          = "10.0.0.0/16"
subnet_cidr       = "10.0.1.0/24"
availability_zone = "us-east-1a"
ssh_allowed_cidr  = ["10.0.0.0/8"]

# Compute
ami_id            = "ami-0c02fb55956c7d316"
instance_type     = "t2.micro"
root_volume_size  = 8

# Storage
versioning_enabled = true
