# Planes de Prueba OPA

Este directorio contiene los planes de Terraform en formato JSON utilizados para validar las políticas de seguridad OPA definidas en `policies/`.

## Escenarios de prueba

| Archivo | Escenario | Resultado esperado |
|---|---|---|
| `plan-conforme.json` | Infraestructura correcta: t2.micro, SSH restringido, S3 privado | ✅ `[]` Sin violaciones |
| `plan-ssh-publico.json` | Security Group con SSH (puerto 22) abierto a `0.0.0.0/0` | ❌ Violación `denegar_public_ssh.rego` |
| `plan-tipo-invalido.json` | Instancia EC2 con tipo `t2.large` (no permitido) | ❌ Violación `solo_t2_micro.rego` |
| `plan-s3-publico.json` | Bucket S3 con `block_public_acls = false` | ❌ Violación `denegar_s3_publico.rego` |

## Cómo ejecutar las pruebas manualmente

```bash
# 1. Instalar OPA (si no está instalado)
curl -L -o opa https://openpolicyagent.org/downloads/latest/opa_linux_amd64_static
chmod +x opa && sudo mv opa /usr/local/bin/

# 2. Prueba 1: Plan conforme - debe retornar []
opa eval -d policies/ -i tests/plan-conforme.json \
  "data.terraform.policies.deny" --format=pretty

# 3. Prueba 2: SSH público - debe retornar mensaje de violación
opa eval -d policies/ -i tests/plan-ssh-publico.json \
  "data.terraform.policies.deny" --format=pretty

# 4. Prueba 3: Tipo inválido - debe retornar mensaje de violación
opa eval -d policies/ -i tests/plan-tipo-invalido.json \
  "data.terraform.policies.deny" --format=pretty

# 5. Prueba 4: S3 público - debe retornar mensaje de violación
opa eval -d policies/ -i tests/plan-s3-publico.json \
  "data.terraform.policies.deny" --format=pretty
```

## Resultados esperados

### Plan conforme
```json
[]
```

### Plan SSH público
```json
[
  "VIOLACION DE SEGURIDAD [IL2.1]: El Security Group 'module.networking.aws_security_group.main' expone el puerto SSH (22) a 0.0.0.0/0."
]
```

### Plan tipo inválido
```json
[
  "VIOLACION DE POLÍTICA [IL2.1]: La instancia 'module.compute.aws_instance.main' usa tipo 't2.large'. Solo se permite t2.micro."
]
```

### Plan S3 público
```json
[
  "VIOLACION DE SEGURIDAD [IL2.1]: El bucket 'module.storage.aws_s3_bucket_public_access_block.main' tiene 'block_public_acls' desactivado."
]
```

## Integración con CI/CD

Estas pruebas se ejecutan automáticamente en el pipeline CI/CD (`.github/workflows/main.yml`) en la **Etapa 4** cada vez que se abre o actualiza un Pull Request hacia `main`.
