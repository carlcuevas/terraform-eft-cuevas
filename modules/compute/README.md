# Módulo: compute

Crea la infraestructura de cómputo en AWS: instancia EC2 `t2.micro`, Key Pair SSH y Elastic IP.

## Uso

```hcl
module "compute" {
  source = "./modules/compute"

  project_name      = "mi-proyecto"
  ami_id            = "ami-0c02fb55956c7d316"
  instance_type     = "t2.micro"
  subnet_id         = module.networking.subnet_id
  security_group_id = module.networking.security_group_id
  public_key        = var.public_key

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
| `ami_id` | `string` | Amazon Linux 2 | ID de la AMI a usar |
| `instance_type` | `string` | `t2.micro` | Tipo de instancia (solo `t2.micro` permitido) |
| `subnet_id` | `string` | — | ID de la subnet (output del módulo networking) |
| `security_group_id` | `string` | — | ID del SG (output del módulo networking) |
| `public_key` | `string` | — | Clave pública SSH (sensible) |
| `root_volume_size` | `number` | `8` | Tamaño del volumen raíz en GB (8-100) |
| `tags` | `map(string)` | `{}` | Etiquetas aplicadas a todos los recursos |

## Outputs

| Output | Descripción |
|---|---|
| `instance_id` | ID de la instancia EC2 |
| `instance_private_ip` | IP privada de la instancia |
| `elastic_ip` | IP pública elástica |
| `key_pair_name` | Nombre del Key Pair |

## Notas de seguridad

- Solo se permite `instance_type = "t2.micro"`. Una validación de Terraform y la política OPA `solo_t2_micro.rego` lo refuerzan en dos capas.
- La variable `public_key` está marcada como `sensitive = true` para evitar que se exponga en los logs.

## Dependencias

- Requiere outputs del módulo `networking`: `subnet_id` y `security_group_id`.
