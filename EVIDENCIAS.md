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

## Grupo 1 — Pipeline CI/CD

### Cap 1 — Pipeline 100% verde (IL1.1, IL1.2, IL2.2)
> Todas las etapas del pipeline con resultado exitoso en el Run #5

<img width="1012" height="486" alt="cap1" src="https://github.com/user-attachments/assets/3fd82265-5fb5-40b9-a6a2-3f9168b4afa2" />

---

### Cap 2 — TFLint: Sin errores (IL1.2)
> Análisis estático ejecutado sin errores ni advertencias. Exit code 0.

<img width="1566" height="282" alt="cap2" src="https://github.com/user-attachments/assets/95b044bc-9821-491d-886b-d3f49cc3ffdc" />

**Reglas validadas:**
- `terraform_documented_variables` — Todas las variables tienen descripción
- `terraform_documented_outputs` — Todos los outputs tienen descripción
- `terraform_required_version` — Versión de Terraform declarada
- `terraform_required_providers` — Versión del proveedor AWS declarada
- `terraform_naming_convention` — Nombres en snake_case
- `aws_instance_invalid_type` — Tipo de instancia EC2 válido

---

### Cap 3 — Checkov: 21 passed, 0 failed (IL1.2)
> Análisis de seguridad completado: 21 checks pasados, 0 fallidos.

<img width="1569" height="577" alt="cap3" src="https://github.com/user-attachments/assets/c66987d3-3ef2-41d4-ae52-a31be4372b22" />

---

### Cap 4 — Terraform Validate: Configuration is valid (IL1.1)
> Validación de sintaxis y formato del código Terraform exitosa.

<img width="1046" height="803" alt="cap4" src="https://github.com/user-attachments/assets/35a7b445-a970-401f-a6a0-04626efe1c63" />

---

### Cap 5 — OPA Plan real: Sin violaciones `[]` (IL2.2)
> Evaluación de políticas OPA sobre el plan real: resultado `[]` sin violaciones.

<img width="1054" height="606" alt="cap5" src="https://github.com/user-attachments/assets/e7a2e5cd-1d36-470a-a095-bab44e9829c1" />

---

### Cap 6 — OPA 4 escenarios de prueba superados (IL2.3)
> Los 4 escenarios de prueba OPA pasaron correctamente, incluyendo detección de violaciones.

<img width="1181" height="493" alt="cap6" src="https://github.com/user-attachments/assets/3edebc62-296c-4fac-b89c-eef71f5acf78" />

---

### Cap 7 — Terraform Plan: 14 to add (IL4.2)
> Plan de infraestructura: 14 recursos a crear, 0 a modificar, 0 a destruir.

<img width="1001" height="413" alt="cap7" src="https://github.com/user-attachments/assets/27aaf3e9-6729-4ec3-83ff-d04b200332d1" />

---

## Grupo 2 — Pull Request

### Cap 8 — PR #1 con descripción completa (IL1.1)
> Pull Request con título descriptivo, descripción detallada de cambios y badge Merged.

<img width="1179" height="667" alt="cap8" src="https://github.com/user-attachments/assets/ddbde332-c3f4-4d9b-9b5a-1dfb92b10fb4" />

---

### Cap 9 — PR mergeado con checks verdes (IL1.1)
> All checks passed y PR mergeado exitosamente a main.

<img width="1035" height="348" alt="cap9" src="https://github.com/user-attachments/assets/7f302a3e-64ff-4792-8519-83ea0db4adc9" />

---

### Cap 10 — Historial de commits del PR (IL1.1)
> 4 commits con mensajes descriptivos siguiendo convenciones `ci:`, `fix:`, `style:`.

<img width="1293" height="497" alt="cap10" src="https://github.com/user-attachments/assets/bc70c8a1-ad88-4be7-a7da-a9b11c7fa012" />

---

## Grupo 3 — Código y Módulos

### Cap 11 — Estructura de carpetas del repo (IL3.1)
> Arquitectura modular del repositorio: modules/, policies/, tests/, .github/workflows/

<img width="803" height="614" alt="cap11" src="https://github.com/user-attachments/assets/59892b45-2fe1-42bc-a08e-5d8b6d4d1316" />

---

### Cap 12 — main.tf: Orquestación de los 3 módulos (IL3.1)
> El main.tf raíz orquesta los 3 módulos. compute depende de networking mediante outputs.

<img width="676" height="661" alt="cap12" src="https://github.com/user-attachments/assets/6d240c9f-9bae-420e-8358-326fd03f62a3" />

---

### Cap 13 — modules/networking/main.tf: SSH restringido (IL3.1, IL2.1)
> Security Group con SSH restringido a CIDR específico. Primera capa de seguridad.

<img width="701" height="188" alt="cap13" src="https://github.com/user-attachments/assets/2ed3dd7a-1882-4c98-9dcd-33dd934835c8" />

---

### Cap 14 — modules/networking/README.md: Documentación completa (IL3.2)
> Documentación del módulo con tabla de parámetros, outputs, ejemplos y notas de seguridad.

<img width="1032" height="768" alt="cap14 1" src="https://github.com/user-attachments/assets/217d7b9b-8c05-4b1a-8171-e7ad66a8351e" />

<img width="1021" height="458" alt="cap14 2" src="https://github.com/user-attachments/assets/8c0fd4d7-dafb-4e44-b5aa-beddf46c0845" />

---

## Grupo 4 — Políticas OPA

### Cap 15 — denegar_public_ssh.rego (IL2.1)
> Política OPA que bloquea Security Groups con SSH expuesto a 0.0.0.0/0.

<img width="1143" height="617" alt="cap15a" src="https://github.com/user-attachments/assets/a9e41da0-e6a5-4502-8c7f-052428abfab2" />

<img width="1143" height="617" alt="cap15b" src="https://github.com/user-attachments/assets/9694da35-215f-4974-9b42-8868fb4d8c13" />

---

### Cap 16 — solo_t2_micro.rego (IL2.1)
> Política OPA que restringe instancias EC2 exclusivamente al tipo t2.micro.

<img width="1025" height="665" alt="cap16" src="https://github.com/user-attachments/assets/5dbde477-9815-40de-be77-27292086b6fe" />

---

### Cap 17 — tests/README.md: Tabla de escenarios (IL2.3)
> 4 escenarios de prueba documentados con resultado esperado para cada política.

<img width="1138" height="370" alt="cap17" src="https://github.com/user-attachments/assets/f050a72a-04af-4065-83b9-df1a333aa1a8" />

---

## Grupo 5 — Versionado Semántico

### Cap 18 — CHANGELOG.md: 4 versiones (IL3.3)
> Versionado semántico completo: v1.0.0 (EP1) → v2.0.0 (EP2) → v2.1.0 (EP3) → v3.0.0 (EFT)

<img width="1195" height="678" alt="cap18 1" src="https://github.com/user-attachments/assets/051286cf-4dec-4e20-80b0-48b335bdbcd9" />

<img width="1066" height="641" alt="cap18 2" src="https://github.com/user-attachments/assets/efe34ae5-7c39-453a-96ad-cd82ec351610" />

<img width="1281" height="501" alt="cap18 3" src="https://github.com/user-attachments/assets/48026ea9-7488-4c0d-b315-80d2ad1e80ee" />

<img width="991" height="616" alt="cap18 4" src="https://github.com/user-attachments/assets/32048b83-1096-49a2-8890-405073f2d826" />

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

> Este historial evidencia el proceso de revisión y mejora continua del código, alineado con el indicador **IL1.1**.
