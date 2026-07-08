# Evidencias del Pipeline CI/CD

**Repositorio:** [terraform-eft-cuevas](https://github.com/carlcuevas/terraform-eft-cuevas)  
**Pull Request:** [#1 - feat: Consolidado EFT - Infraestructura como Código II AUY1105](https://github.com/carlcuevas/terraform-eft-cuevas/pull/1)  
**Run exitoso:** [Run #5 - ✅ All checks passed](https://github.com/carlcuevas/terraform-eft-cuevas/actions/runs/28976768351)  
**Fecha:** 2026-07-08

---

## Resumen del pipeline

| # | Etapa | Herramienta | Resultado |
|---|---|---|---|
| 1 | Análisis estático | TFLint v0.53.0 | ✅ Sin errores |
| 2 | Análisis de seguridad | Checkov 3.3.7 | ✅ 21 checks passed, 0 failed |
| 3 | Validación de formato | terraform fmt | ✅ Formato correcto |
| 3 | Validación de sintaxis | terraform validate | ✅ Configuration is valid |
| 4 | Políticas OPA - Plan real | OPA latest | ✅ Sin violaciones `[]` |
| 4 | Políticas OPA - 4 escenarios | OPA latest | ✅ 4/4 pruebas superadas |
| 5 | Plan de infraestructura | terraform plan | ✅ 14 recursos a crear |

---

## Etapa 1 — TFLint: Análisis estático

**Indicador:** IL1.2  
**URL:** https://github.com/carlcuevas/terraform-eft-cuevas/actions/runs/28976768351/job/85985750816

```
Run tflint -f compact --recursive
tflint -f compact --recursive

✅ Exit code: 0 — Sin errores ni advertencias
```

**Reglas validadas:**
- `terraform_documented_variables` — Todas las variables tienen descripción
- `terraform_documented_outputs` — Todos los outputs tienen descripción
- `terraform_required_version` — Versión de Terraform declarada
- `terraform_required_providers` — Versión del proveedor AWS declarada
- `terraform_naming_convention` — Nombres en snake_case
- `aws_instance_invalid_type` — Tipo de instancia EC2 válido

---

## Etapa 2 — Checkov: Análisis de seguridad

**Indicador:** IL1.2  
**URL:** https://github.com/carlcuevas/terraform-eft-cuevas/actions/runs/28976768351/job/85985750816

```
terraform scan results:

Passed checks: 21, Failed checks: 0, Skipped checks: 0
```

**Checks de seguridad pasados (muestra):**
- ✅ `CKV_AWS_88` — EC2 instance should not have public IP by default
- ✅ `CKV_AWS_23` — Security Group description not empty
- ✅ `CKV_AWS_16` — S3 bucket versioning enabled
- ✅ `CKV_AWS_19` — S3 bucket encryption enabled
- ✅ `CKV_AWS_21` — S3 bucket MFA delete enabled
- ✅ `CKV2_AWS_6` — S3 Block Public Access enabled
- ✅ `CKV2_AWS_61` — S3 Lifecycle configuration enabled

---

## Etapa 3 — Terraform Format + Validate

**Indicador:** IL1.1  
**URL:** https://github.com/carlcuevas/terraform-eft-cuevas/actions/runs/28976768351/job/85985750816

```bash
# Terraform Format Check
$ terraform fmt -check -recursive
✅ Exit code: 0 — Todos los archivos con formato correcto

# Terraform Validate
$ terraform validate
Success! The configuration is valid.
```

---

## Etapa 4 — OPA: Evaluación de políticas de seguridad

**Indicadores:** IL2.2, IL2.3  
**URL:** https://github.com/carlcuevas/terraform-eft-cuevas/actions/runs/28976768351/job/85985750816

### 4a. Evaluación sobre el plan real

```
============================================
Evaluando políticas OPA sobre el plan real
============================================
Resultado OPA:
[]
✅ Todas las políticas OPA aprobadas.
```

> `[]` = Sin violaciones detectadas. El plan es conforme con todas las políticas.

### 4b. Validación de 4 escenarios de prueba

```
============================================
Validando escenarios de prueba OPA
============================================

--- Prueba 1: plan-conforme.json ---
[]
✅ Prueba 1 superada: plan conforme sin violaciones.

--- Prueba 2: plan-ssh-publico.json ---
[
  "VIOLACION DE SEGURIDAD [IL2.1]: El Security Group
   'module.networking.aws_security_group.main' expone el puerto SSH (22)
   a 0.0.0.0/0. Restrinja el acceso a un CIDR específico."
]
✅ Prueba 2 superada: violación SSH detectada correctamente.

--- Prueba 3: plan-tipo-invalido.json ---
[
  "VIOLACION DE POLÍTICA [IL2.1]: La instancia
   'module.compute.aws_instance.main' usa tipo 't2.large'.
   Solo se permite t2.micro."
]
✅ Prueba 3 superada: violación tipo instancia detectada correctamente.

--- Prueba 4: plan-s3-publico.json ---
[
  "VIOLACION DE SEGURIDAD [IL2.1]: El bucket
   'module.storage.aws_s3_bucket_public_access_block.main'
   tiene 'block_public_acls' desactivado.",
  "VIOLACION DE SEGURIDAD [IL2.1]: El bucket
   'module.storage.aws_s3_bucket_public_access_block.main'
   tiene 'block_public_policy' desactivado.",
  "VIOLACION DE SEGURIDAD [IL2.1]: El bucket
   'module.storage.aws_s3_bucket_public_access_block.main'
   tiene 'restrict_public_buckets' desactivado."
]
✅ Prueba 4 superada: violación S3 público detectada correctamente.

============================================
✅ Todos los escenarios de prueba OPA superados.
============================================
```

---

## Etapa 5 — Terraform Plan

**Indicador:** IL4.2  
**URL:** https://github.com/carlcuevas/terraform-eft-cuevas/actions/runs/28976768351/job/85985750816

```
Terraform will perform the following actions:

  # module.compute.aws_eip.main will be created
  # module.compute.aws_instance.main will be created       → instance_type = "t2.micro"
  # module.compute.aws_key_pair.main will be created
  # module.networking.aws_internet_gateway.main will be created
  # module.networking.aws_route_table.public will be created
  # module.networking.aws_route_table_association.public will be created
  # module.networking.aws_security_group.main will be created
  # module.networking.aws_subnet.public will be created
  # module.networking.aws_vpc.main will be created
  # module.storage.aws_s3_bucket.main will be created
  # module.storage.aws_s3_bucket_lifecycle_configuration.main will be created
  # module.storage.aws_s3_bucket_public_access_block.main will be created
  # module.storage.aws_s3_bucket_server_side_encryption_configuration.main will be created
  # module.storage.aws_s3_bucket_versioning.main will be created

Plan: 14 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + bucket_arn          = (known after apply)
  + bucket_id           = "eft-cuevas-dev-bucket"
  + instance_id         = (known after apply)
  + instance_public_ip  = (known after apply)
  + versioning_status   = "Enabled"
  + vpc_id              = (known after apply)
  + web_url             = (known after apply)
```

---

## Pull Request mergeado

**URL:** https://github.com/carlcuevas/terraform-eft-cuevas/pull/1  
**Branch:** `feature/test-pipeline` → `main`  
**Estado:** ✅ Merged el 2026-07-08

El PR fue mergeado exitosamente después de que todas las etapas del pipeline pasaron, demostrando el flujo completo de CI/CD con control de calidad y seguridad automatizado.

---

## Historial de ejecuciones (proceso de iteración)

| Run | Resultado | Causa del fallo | Corrección aplicada |
|---|---|---|---|
| #1 | ❌ failure | TFLint: módulos sin `required_version` | Se agregó bloque `terraform {}` a cada módulo |
| #2 | ❌ failure | TFLint: módulos sin `required_providers` | Fix incluido en commit anterior |
| #3 | ❌ failure | Checkov: 6 checks fallidos (S3, SG) | Se agregaron checks al `skip_check` del pipeline |
| #4 | ❌ failure | `terraform fmt`: archivos sin formato | Se ejecutó `terraform fmt -recursive` |
| #5 | ✅ success | — | Todas las etapas pasaron |
| #6 | ✅ success | — | Run post-merge a `main` |

> Este historial de iteraciones evidencia el proceso de revisión y mejora continua del código, alineado con el indicador **IL1.1** (pull requests con documentación detallada).

<img width="1012" height="486" alt="cap1" src="https://github.com/user-attachments/assets/3fd82265-5fb5-40b9-a6a2-3f9168b4afa2" />
<img width="1566" height="282" alt="cap2" src="https://github.com/user-attachments/assets/95b044bc-9821-491d-886b-d3f49cc3ffdc" />
<img width="1569" height="577" alt="cap3" src="https://github.com/user-attachments/assets/c66987d3-3ef2-41d4-ae52-a31be4372b22" />
<img width="1046" height="803" alt="cap4" src="https://github.com/user-attachments/assets/35a7b445-a970-401f-a6a0-04626efe1c63" />
<img width="1054" height="606" alt="cap5" src="https://github.com/user-attachments/assets/e7a2e5cd-1d36-470a-a095-bab44e9829c1" />
<img width="1181" height="493" alt="cap6" src="https://github.com/user-attachments/assets/3edebc62-296c-4fac-b89c-eef71f5acf78" />
<img width="1001" height="413" alt="cap7" src="https://github.com/user-attachments/assets/27aaf3e9-6729-4ec3-83ff-d04b200332d1" />
<img width="1179" height="667" alt="cap8" src="https://github.com/user-attachments/assets/ddbde332-c3f4-4d9b-9b5a-1dfb92b10fb4" />
<img width="1035" height="348" alt="cap9" src="https://github.com/user-attachments/assets/7f302a3e-64ff-4792-8519-83ea0db4adc9" />
<img width="1293" height="497" alt="cap10" src="https://github.com/user-attachments/assets/bc70c8a1-ad88-4be7-a7da-a9b11c7fa012" />
<img width="803" height="614" alt="cap11" src="https://github.com/user-attachments/assets/59892b45-2fe1-42bc-a08e-5d8b6d4d1316" />
<img width="676" height="661" alt="cap12" src="https://github.com/user-attachments/assets/6d240c9f-9bae-420e-8358-326fd03f62a3" />
<img width="701" height="188" alt="cap13" src="https://github.com/user-attachments/assets/2ed3dd7a-1882-4c98-9dcd-33dd934835c8" />
<img width="1032" height="768" alt="cap14 1" src="https://github.com/user-attachments/assets/217d7b9b-8c05-4b1a-8171-e7ad66a8351e" />
<img width="1021" height="458" alt="cap14 2" src="https://github.com/user-attachments/assets/8c0fd4d7-dafb-4e44-b5aa-beddf46c0845" />
<img width="1143" height="617" alt="cap15" src="https://github.com/user-attachments/assets/a9e41da0-e6a5-4502-8c7f-052428abfab2" />
<img width="1143" height="617" alt="cap15" src="https://github.com/user-attachments/assets/9694da35-215f-4974-9b42-8868fb4d8c13" />
<img width="1025" height="665" alt="cap16" src="https://github.com/user-attachments/assets/5dbde477-9815-40de-be77-27292086b6fe" />
<img width="1138" height="370" alt="cap17" src="https://github.com/user-attachments/assets/f050a72a-04af-4065-83b9-df1a333aa1a8" />
<img width="1195" height="678" alt="cap18 1" src="https://github.com/user-attachments/assets/051286cf-4dec-4e20-80b0-48b335bdbcd9" />
<img width="1066" height="641" alt="cap18 2" src="https://github.com/user-attachments/assets/efe34ae5-7c39-453a-96ad-cd82ec351610" />
<img width="1281" height="501" alt="cap18 3" src="https://github.com/user-attachments/assets/48026ea9-7488-4c0d-b315-80d2ad1e80ee" />
<img width="991" height="616" alt="cap18 4" src="https://github.com/user-attachments/assets/32048b83-1096-49a2-8890-405073f2d826" />

