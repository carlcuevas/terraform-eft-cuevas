# Módulo: networking

Crea la infraestructura de red base en AWS: VPC, Subnet pública, Internet Gateway, Route Table y Security Group.

## Uso

```hcl
module "networking" {
  source = "./modules/networking"

  project_name      = "mi-proyecto"
  vpc_cidr          = "10.0.0.0/16"
  subnet_cidr       = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  ssh_allowed_cidr  = ["203.0.113.0/24"]

  tags = {
    Environment = "produccion"
    Project     = "mi-proyecto"
  }
}
```

## Parámetros configurables

| Variable | Tipo | Default | Descripción |
|---|---|---|---|
| `project_name` | `string` | — | Prefijo usado en todos los recursos |
| `vpc_cidr` | `string` | `10.0.0.0/16` | Bloque CIDR de la VPC |
| `subnet_cidr` | `string` | `10.0.1.0/24` | Bloque CIDR de la subnet pública |
| `availability_zone` | `string` | `us-east-1a` | AZ donde se despliega la subnet |
| `ssh_allowed_cidr` | `list(string)` | `["10.0.0.0/8"]` | CIDRs con acceso SSH (nunca `0.0.0.0/0`) |
| `tags` | `map(string)` | `{}` | Etiquetas aplicadas a todos los recursos |

## Outputs

| Output | Descripción |
|---|---|
| `vpc_id` | ID de la VPC creada |
| `subnet_id` | ID de la subnet pública |
| `security_group_id` | ID del Security Group |
| `internet_gateway_id` | ID del Internet Gateway |

## Notas de seguridad

- El puerto SSH (22) **nunca** se expone a `0.0.0.0/0`. La variable `ssh_allowed_cidr` tiene una validación que lo impide.
- Compatible con las políticas OPA del módulo `policies/`.

## Dependencias

Este módulo no depende de otros módulos. Es la base de la arquitectura.
