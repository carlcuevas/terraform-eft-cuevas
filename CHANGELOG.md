# Changelog

Todos los cambios notables de este proyecto están documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es/1.0.0/),
y este proyecto adhiere al [Versionado Semántico](https://semver.org/lang/es/).

## Formato de versiones

```
MAJOR.MINOR.PATCH

MAJOR → Cambios incompatibles con versiones anteriores
MINOR → Nueva funcionalidad compatible con versiones anteriores
PATCH → Correcciones de errores compatibles con versiones anteriores
```

---

## [3.0.0] - Evaluación Final Transversal

### Agregado
- Política OPA `denegar_s3_publico.rego` para validar configuración de acceso público en buckets S3
- Plan de prueba `plan-s3-publico.json` para validar la nueva política OPA
- Etapa 5 en pipeline CI/CD: `terraform plan` con reporte de cambios
- Validación de 4 escenarios de prueba OPA automatizados en el pipeline
- `terraform fmt -check` integrado en el pipeline para garantizar formato uniforme
- Elastic IP asociada a la instancia EC2 para IP pública estática
- Output `web_url` para acceso directo al servidor web desplegado
- Configuración de ciclo de vida en S3 para optimización de costos
- Reglas de TFLint: `terraform_naming_convention`, `terraform_unused_declarations`

### Modificado
- Pipeline CI/CD ampliado de 4 a 5 etapas con validaciones más exhaustivas
- Módulo `compute` ahora incluye `aws_eip` para IP pública estática
- Módulo `storage` ahora incluye `aws_s3_bucket_lifecycle_configuration`
- README consolidado como informe final de la EFT

### Compatibilidad con versiones anteriores
- ✅ Compatible con `v2.x`: los módulos mantienen la misma interfaz de variables y outputs
- ✅ Los recursos existentes no requieren recreación al actualizar desde `v2.x`

---

## [2.0.0] - Evaluación Parcial N°2

### Agregado
- Módulo `networking` con VPC, Subnet pública, Internet Gateway, Route Table y Security Group
- Módulo `compute` con instancia EC2 t2.micro y Key Pair
- Módulo `storage` con bucket S3 privado, versionado y cifrado SSE-S3
- Variables con validaciones integradas en cada módulo
- Outputs descriptivos en cada módulo y en la raíz del proyecto
- README individual para cada módulo con ejemplos de uso y tabla de parámetros
- Archivo `.tflint.hcl` con plugin AWS y reglas de buenas prácticas

### Modificado
- Refactorización completa: arquitectura monolítica migrada a módulos reutilizables
- `variables.tf` descompuesto por responsabilidad en cada módulo
- `outputs.tf` descompuesto por responsabilidad en cada módulo

### Eliminado
- `main.tf` monolítico de v1.0.0 reemplazado por estructura modular

### Compatibilidad con versiones anteriores
- ⚠️ BREAKING CHANGE: la estructura de archivos cambió completamente
- Los recursos de infraestructura son equivalentes pero requieren `terraform state mv` para migrar el estado existente

---

## [1.0.0] - Evaluación Parcial N°1

### Agregado
- Infraestructura base en AWS: VPC, Subnet pública, Internet Gateway, Route Table
- Security Group con reglas HTTP (80), HTTPS (443) y SSH restringido
- Instancia EC2 t2.micro con Amazon Linux 2
- Bucket S3 con Block Public Access y cifrado SSE-S3
- Pipeline CI/CD en GitHub Actions con 4 etapas:
  - TFLint: análisis estático del código
  - Checkov: análisis de seguridad
  - Terraform Validate: validación de sintaxis
  - OPA: evaluación de políticas de seguridad
- Política OPA `denegar_public_ssh.rego`: bloquea SSH expuesto a `0.0.0.0/0`
- Política OPA `solo_t2_micro.rego`: restringe tipo de instancia a t2.micro
- Planes de prueba JSON:
  - `plan-conforme.json`: infraestructura válida sin violaciones
  - `plan-ssh-publico.json`: escenario con SSH inseguro
  - `plan-tipo-invalido.json`: escenario con instancia no permitida
- Archivo `.gitignore` con exclusiones de archivos Terraform sensibles
- `terraform.tfvars` con valores por defecto del proyecto

### Compatibilidad con versiones anteriores
- Versión inicial, no aplica.

---

## Roadmap

| Versión | Descripción |
|---|---|
| `v3.1.0` | Agregar módulo de base de datos RDS |
| `v3.2.0` | Agregar Application Load Balancer |
| `v4.0.0` | Migración a backend remoto S3 + DynamoDB para estado compartido |
