# Módulo: storage

Crea la infraestructura de almacenamiento en AWS: bucket S3 privado con versionado, cifrado SSE-S3 y política de ciclo de vida.

## Uso

```hcl
module "storage" {
  source = "./modules/storage"

  project_name       = "mi-proyecto"
  environment        = "prod"
  versioning_enabled = true

  tags = {
    Environment = "prod"
    Project     = "mi-proyecto"
  }
}
```

## Parámetros configurables

| Variable | Tipo | Default | Descripción |
|---|---|---|---|
| `project_name` | `string` | — | Prefijo del nombre del bucket |
| `environment` | `string` | `dev` | Entorno: `dev`, `staging` o `prod` |
| `versioning_enabled` | `bool` | `true` | Habilitar versionado S3 |
| `tags` | `map(string)` | `{}` | Etiquetas aplicadas a todos los recursos |

## Outputs

| Output | Descripción |
|---|---|
| `bucket_id` | Nombre del bucket S3 |
| `bucket_arn` | ARN del bucket S3 |
| `bucket_domain_name` | Dominio del bucket |
| `versioning_status` | Estado del versionado (`Enabled` / `Suspended`) |

## Características de seguridad

- **Block Public Access**: todos los accesos públicos bloqueados por defecto.
- **Cifrado SSE-S3**: cifrado en reposo con AES-256 habilitado automáticamente.
- **Versionado**: protección ante borrado o sobreescritura accidental.
- **Ciclo de vida**: transición a `STANDARD_IA` a los 30 días y expiración de versiones antiguas a los 90 días.

## Dependencias

Este módulo no depende de otros módulos. Puede desplegarse de forma independiente.
