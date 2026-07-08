# =============================================================================
# Módulo: compute
# -----------------------------------------------------------------------------
# Crea la infraestructura de cómputo:
#   - Instancia EC2 t2.micro (política OPA IL2.1)
#   - Key Pair para acceso SSH
#   - Elastic IP asociada a la instancia
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

resource "aws_key_pair" "main" {
  key_name   = "${var.project_name}-keypair"
  public_key = var.public_key

  tags = merge(var.tags, {
    Name = "${var.project_name}-keypair"
  })
}

resource "aws_instance" "main" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = aws_key_pair.main.key_name

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = "gp2"
    delete_on_termination = true
  }

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Infraestructura como Codigo - EFT AUY1105</h1>" > /var/www/html/index.html
  EOF

  tags = merge(var.tags, {
    Name = "${var.project_name}-ec2"
  })
}

resource "aws_eip" "main" {
  instance = aws_instance.main.id
  domain   = "vpc"

  tags = merge(var.tags, {
    Name = "${var.project_name}-eip"
  })
}
