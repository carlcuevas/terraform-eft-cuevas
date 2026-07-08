# Políticas de Seguridad OPA

Este directorio contiene las políticas de seguridad implementadas con **Open Policy Agent (OPA)** para validar el plan de Terraform antes de cualquier despliegue.

## Políticas implementadas

| Archivo | Descripción | Indicador |
|---|---|---|
| `denegar_public_ssh.rego` | Bloquea Security Groups con SSH (puerto 22) abierto a `0.0.0.0/0` | IL2.1 |
| `solo_t2_micro.rego` | Restringe instancias EC2 exclusivamente al tipo `t2.micro` | IL2.1 |
| `denegar_s3_publico.rego` | Bloquea buckets S3 con acceso público habilitado | IL2.1 |

## ¿Cómo funcionan?

Todas las políticas usan el paquete `terraform.policies` y exponen un conjunto `deny` con mensajes descriptivos. El pipeline CI/CD evalúa el plan JSON contra estas políticas antes de permitir el merge de un Pull Request.

```bash
# Evaluar políticas manualmente
opa eval -d policies/ -i plan.json "data.terraform.policies.deny" --format=pretty
```

## Escenarios de prueba

Los planes JSON de prueba están en el directorio `tests/`:

| Plan | Descripción | Resultado esperado |
|---|---|---|
| `plan-conforme.json` | Infraestructura correcta: t2.micro, SSH restringido, S3 privado | ✅ Sin violaciones |
| `plan-ssh-publico.json` | Security Group con SSH abierto a `0.0.0.0/0` | ❌ Violación detectada |
| `plan-tipo-invalido.json` | Instancia EC2 con tipo `t2.large` | ❌ Violación detectada |
| `plan-s3-publico.json` | Bucket S3 con acceso público habilitado | ❌ Violación detectada |

## Alineación con estándares

Estas políticas se alinean con:
- **CIS AWS Foundations Benchmark**: control de acceso SSH y S3
- **AWS Well-Architected Framework**: principio de menor privilegio
- **Requisitos del curso AUY1105**: indicadores IL2.1, IL2.2, IL2.3
