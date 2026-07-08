# Infraestructura como Código II — Evaluación Final Transversal

**Asignatura:** AUY1105 - Infraestructura como Código II  
**Estudiante:** Carlos Cuevas  
**Versión:** 3.0.0  
**Tecnología principal:** Terraform + AWS + GitHub Actions + OPA

---

## Tabla de contenidos

1. [Introducción](#1-introducción)
2. [Alcance](#2-alcance)
3. [Diseño de la solución](#3-diseño-de-la-solución)
4. [Diagrama de arquitectura](#4-diagrama-de-arquitectura)
5. [Módulos Terraform](#5-módulos-terraform)
6. [Políticas de seguridad OPA](#6-políticas-de-seguridad-opa)
7. [Pipeline CI/CD](#7-pipeline-cicd)
8. [Análisis estático de código](#8-análisis-estático-de-código)
9. [Versionado semántico](#9-versionado-semántico)
10. [Cómo desplegar](#10-cómo-desplegar)
11. [Conclusiones](#11-conclusiones)
12. [Anexos](#12-anexos)

---

## 1. Introducción

Este proyecto representa el consolidado final de las Evaluaciones Parciales 1, 2 y 3 de la asignatura **AUY1105 - Infraestructura como Código II**. El objetivo central es demostrar el diseño, implementación y operación de una solución de infraestructura en la nube utilizando **Terraform** como tecnología de Infraestructura como Código (IaC).

La solución aborda los siguientes desafíos técnicos identificados a lo largo de las evaluaciones parciales:

- **EP1:** Implementación de una infraestructura base segura en AWS con un pipeline CI/CD y políticas de seguridad automatizadas con OPA.
- **EP2:** Refactorización a una arquitectura modular y reutilizable, aplicando las mejores prácticas de codificación Terraform.
- **EP3:** Gestión avanzada del estado de Terraform y optimización de las configuraciones de infraestructura.

El resultado final es una plataforma de infraestructura **segura, modular, documentada y automatizada**, capaz de desplegarse de forma consistente y reproducible en cualquier entorno AWS.

---

## 2. Alcance

### Objetivos

| # | Objetivo | Estado |
|---|---|---|
| 1 | Implementar infraestructura de red segura (VPC, Subnet, SG) en AWS | ✅ Completado |
| 2 | Desplegar instancia de cómputo EC2 t2.micro con acceso controlado | ✅ Completado |
| 3 | Configurar almacenamiento S3 privado con cifrado y versionado | ✅ Completado |
| 4 | Desarrollar módulos Terraform reutilizables con documentación completa | ✅ Completado |
| 5 | Implementar políticas de seguridad OPA con pruebas en múltiples escenarios | ✅ Completado |
| 6 | Automatizar el flujo de calidad y seguridad mediante pipeline CI/CD | ✅ Completado |
| 7 | Aplicar versionado semántico a los módulos del proyecto | ✅ Completado |

### Recursos implementados

| Recurso AWS | Módulo | Descripción |
|---|---|---|
| `aws_vpc` | networking | Red virtual privada con DNS habilitado |
| `aws_subnet` | networking | Subnet pública con asignación automática de IP |
| `aws_internet_gateway` | networking | Puerta de enlace a internet |
| `aws_route_table` | networking | Tabla de rutas con ruta por defecto a IGW |
| `aws_security_group` | networking | Firewall: HTTP/HTTPS públicos, SSH restringido |
| `aws_instance` | compute | EC2 t2.micro con Amazon Linux 2 y Apache |
| `aws_key_pair` | compute | Par de claves SSH para acceso seguro |
| `aws_eip` | compute | IP elástica pública estática |
| `aws_s3_bucket` | storage | Bucket S3 privado |
| `aws_s3_bucket_public_access_block` | storage | Bloqueo total de acceso público |
| `aws_s3_bucket_versioning` | storage | Versionado para protección de datos |
| `aws_s3_bucket_server_side_encryption_configuration` | storage | Cifrado AES-256 en reposo |
| `aws_s3_bucket_lifecycle_configuration` | storage | Ciclo de vida para optimización de costos |

### Criterios de éxito

- ✅ Pipeline CI/CD ejecuta sin errores en Pull Requests hacia `main`
- ✅ Las 3 políticas OPA detectan correctamente las 3 violaciones de seguridad
- ✅ El plan conforme no genera ninguna violación OPA
- ✅ TFLint y Checkov no reportan errores críticos
- ✅ Los 3 módulos son reutilizables e independientes entre sí
- ✅ El versionado semántico refleja correctamente el historial de cambios

---

## 3. Diseño de la solución

### Arquitectura general

La solución adopta una **arquitectura modular de tres capas** separadas por responsabilidad:

```
┌─────────────────────────────────────────┐
│           Capa de Orquestación          │
│              main.tf (raíz)             │
└────────────┬────────────┬───────────────┘
             │            │            │
     ┌───────▼──┐  ┌──────▼───┐  ┌────▼─────┐
     │networking│  │ compute  │  │ storage  │
     │  módulo  │  │  módulo  │  │  módulo  │
     └──────────┘  └──────────┘  └──────────┘
```

### Componentes clave

**1. Módulo Networking**
Establece el perímetro de red. Crea la VPC con sus componentes asociados y define las reglas de acceso mediante el Security Group. El diseño garantiza que SSH nunca sea expuesto a `0.0.0.0/0`, validado tanto por una regla de Terraform como por la política OPA correspondiente.

**2. Módulo Compute**
Despliega la instancia de cómputo sobre la red creada por el módulo anterior. Usa una Elastic IP para garantizar una dirección pública estática. El `user_data` configura automáticamente Apache al iniciar la instancia.

**3. Módulo Storage**
Provisiona el almacenamiento de objetos con todas las configuraciones de seguridad requeridas: bloqueo de acceso público, cifrado en reposo y versionado activado. La política de ciclo de vida optimiza costos moviendo objetos a STANDARD_IA tras 30 días.

**4. Pipeline CI/CD**
Automatiza el proceso de validación y despliegue en 5 etapas secuenciales que deben completarse correctamente para que un Pull Request sea fusionable.

**5. Políticas OPA**
Actúan como un sistema de permisos automatizado que evalúa el plan de Terraform antes de cualquier despliegue, previniendo configuraciones inseguras o no conformes.

### Herramientas y tecnologías

| Herramienta | Versión | Propósito |
|---|---|---|
| Terraform | >= 1.9.0 | IaC principal |
| AWS Provider | ~> 5.0 | Proveedor cloud |
| GitHub Actions | - | Pipeline CI/CD |
| OPA | latest | Políticas de seguridad |
| TFLint | v0.53.0 | Análisis estático |
| Checkov | latest | Seguridad y cumplimiento |

---

## 4. Diagrama de arquitectura

```
                          Internet
                             │
                             ▼
                    ┌─────────────────┐
                    │  Internet       │
                    │  Gateway        │
                    └────────┬────────┘
                             │
              ┌──────────────▼──────────────┐
              │         AWS VPC             │
              │      10.0.0.0/16            │
              │                             │
              │  ┌────────────────────────┐ │
              │  │   Subnet Pública       │ │
              │  │   10.0.1.0/24          │ │
              │  │   us-east-1a           │ │
              │  │                        │ │
              │  │  ┌──────────────────┐  │ │
              │  │  │  Security Group  │  │ │
              │  │  │  ┌────────────┐  │  │ │
              │  │  │  │ IN: 80/tcp │  │  │ │
              │  │  │  │ IN: 443/tcp│  │  │ │
              │  │  │  │ IN: 22/tcp │  │  │ │
              │  │  │  │ (restringido) │  │ │
              │  │  │  │ OUT: all   │  │  │ │
              │  │  │  └────────────┘  │  │ │
              │  │  │                  │  │ │
              │  │  │  ┌────────────┐  │  │ │
              │  │  │  │  EC2       │  │  │ │
              │  │  │  │ t2.micro   │  │  │ │
              │  │  │  │ Amazon     │  │  │ │
              │  │  │  │ Linux 2    │  │  │ │
              │  │  │  │ + Apache   │  │  │ │
              │  │  │  └─────┬──────┘  │  │ │
              │  │  └────────┼─────────┘  │ │
              │  └───────────┼────────────┘ │
              └──────────────┼──────────────┘
                             │ Elastic IP
                             ▼
                      [IP Pública Estática]

              ┌─────────────────────────────┐
              │         AWS S3              │
              │   eft-cuevas-dev-bucket     │
              │   ✅ Block Public Access    │
              │   ✅ Versioning Enabled     │
              │   ✅ SSE-S3 (AES-256)       │
              │   ✅ Lifecycle Policy       │
              └─────────────────────────────┘

              ┌─────────────────────────────┐
              │      GitHub Actions         │
              │   Pipeline CI/CD            │
              │                             │
              │  PR → [TFLint]             │
              │      → [Checkov]           │
              │      → [TF Validate]       │
              │      → [OPA Policies]      │
              │      → [TF Plan]           │
              │      → ✅ Merge allowed    │
              └─────────────────────────────┘
```

---

## 5. Módulos Terraform

El proyecto está organizado en tres módulos independientes y reutilizables:

### 5.1 Módulo `networking`

**Ubicación:** `modules/networking/`

Gestiona todos los recursos de red. Incluye validaciones que impiden configuraciones inseguras directamente en Terraform:

```hcl
module "networking" {
  source            = "./modules/networking"
  project_name      = "mi-proyecto"
  vpc_cidr          = "10.0.0.0/16"
  subnet_cidr       = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  ssh_allowed_cidr  = ["203.0.113.0/24"]  # Nunca 0.0.0.0/0
}
```

### 5.2 Módulo `compute`

**Ubicación:** `modules/compute/`

Gestiona la instancia EC2 y sus recursos asociados. Depende de los outputs del módulo `networking`:

```hcl
module "compute" {
  source            = "./modules/compute"
  project_name      = "mi-proyecto"
  instance_type     = "t2.micro"           # Solo t2.micro permitido
  subnet_id         = module.networking.subnet_id
  security_group_id = module.networking.security_group_id
  public_key        = var.public_key
}
```

### 5.3 Módulo `storage`

**Ubicación:** `modules/storage/`

Gestiona el bucket S3 con todas las configuraciones de seguridad habilitadas por defecto:

```hcl
module "storage" {
  source             = "./modules/storage"
  project_name       = "mi-proyecto"
  environment        = "prod"
  versioning_enabled = true
}
```

---

## 6. Políticas de seguridad OPA

### Políticas implementadas

| Política | Archivo | Descripción |
|---|---|---|
| Denegar SSH público | `denegar_public_ssh.rego` | Bloquea SG con puerto 22 abierto a `0.0.0.0/0` |
| Solo t2.micro | `solo_t2_micro.rego` | Restringe EC2 a tipo `t2.micro` únicamente |
| Denegar S3 público | `denegar_s3_publico.rego` | Bloquea buckets con acceso público habilitado |

### Resultados de pruebas

| Escenario | Plan | Resultado | Política activada |
|---|---|---|---|
| Infraestructura conforme | `plan-conforme.json` | ✅ Sin violaciones | — |
| SSH expuesto a internet | `plan-ssh-publico.json` | ❌ Violación detectada | `denegar_public_ssh.rego` |
| EC2 con tipo no permitido | `plan-tipo-invalido.json` | ❌ Violación detectada | `solo_t2_micro.rego` |
| S3 con acceso público | `plan-s3-publico.json` | ❌ Violación detectada | `denegar_s3_publico.rego` |

### Ejecución manual

```bash
# Evaluar todas las políticas sobre el plan real
opa eval -d policies/ -i plan.json "data.terraform.policies.deny" --format=pretty
```

---

## 7. Pipeline CI/CD

El pipeline se ejecuta automáticamente en cada Pull Request hacia `main` y en cada push a `main`.

### Etapas del pipeline

```
Pull Request → main
       │
       ▼
┌──────────────────────────────────────────────────────┐
│  Etapa 1: TFLint                                     │
│  Análisis estático: naming, documentación, tipos     │
│  ✅ Pass → continúa  ❌ Fail → bloquea PR            │
└──────────────────────┬───────────────────────────────┘
                       ▼
┌──────────────────────────────────────────────────────┐
│  Etapa 2: Checkov                                    │
│  Seguridad: cifrado, acceso público, IAM             │
│  ✅ Pass → continúa  ❌ Fail → bloquea PR            │
└──────────────────────┬───────────────────────────────┘
                       ▼
┌──────────────────────────────────────────────────────┐
│  Etapa 3: Terraform Format + Validate                │
│  Formato uniforme y sintaxis correcta                │
│  ✅ Pass → continúa  ❌ Fail → bloquea PR            │
└──────────────────────┬───────────────────────────────┘
                       ▼
┌──────────────────────────────────────────────────────┐
│  Etapa 4: OPA Policies                               │
│  Evaluación de 3 políticas + 4 escenarios de prueba  │
│  ✅ Pass → continúa  ❌ Fail → bloquea PR            │
└──────────────────────┬───────────────────────────────┘
                       ▼
┌──────────────────────────────────────────────────────┐
│  Etapa 5: Terraform Plan                             │
│  Genera y reporta el plan de cambios                 │
│  ✅ Pass → PR aprobado para merge                    │
└──────────────────────────────────────────────────────┘
```

### Secrets requeridos en GitHub

Para que el pipeline funcione correctamente, se deben configurar los siguientes secrets en el repositorio:

| Secret | Descripción |
|---|---|
| `AWS_ACCESS_KEY_ID` | ID de clave de acceso AWS |
| `AWS_SECRET_ACCESS_KEY` | Clave de acceso secreta AWS |
| `AWS_SESSION_TOKEN` | Token de sesión (requerido en AWS Academy) |

---

## 8. Análisis estático de código

### TFLint

TFLint se ejecuta en la Etapa 1 del pipeline con el plugin AWS habilitado. Las reglas configuradas en `.tflint.hcl` validan:

- ✅ Todas las variables tienen descripción (`terraform_documented_variables`)
- ✅ Todos los outputs tienen descripción (`terraform_documented_outputs`)
- ✅ Convención `snake_case` en nombres de recursos y variables (`terraform_naming_convention`)
- ✅ Versión de Terraform declarada (`terraform_required_version`)
- ✅ Versiones de proveedores declaradas (`terraform_required_providers`)
- ✅ Variables no utilizadas detectadas (`terraform_unused_declarations`)
- ✅ Tipos de instancia EC2 válidos en AWS (`aws_instance_invalid_type`)

### Checkov

Checkov analiza el código en busca de configuraciones de seguridad incorrectas. Los checks activos validan:

- ✅ Bucket S3 con cifrado habilitado
- ✅ Bucket S3 con versionado habilitado
- ✅ Bucket S3 con Block Public Access
- ✅ Security Group sin exposición innecesaria de puertos
- ✅ Instancia EC2 sin metadatos IMDSv1 expuestos

---

## 9. Versionado semántico

Este proyecto sigue el estándar [SemVer 2.0.0](https://semver.org/lang/es/):

| Versión | Fecha | Descripción |
|---|---|---|
| `v1.0.0` | 2024-09-20 | EP1: Infraestructura base + pipeline CI/CD + políticas OPA |
| `v2.0.0` | 2024-10-18 | EP2: Refactorización a módulos reutilizables |
| `v3.0.0` | 2024-11-15 | EFT: Consolidado final con nuevas políticas y optimizaciones |

El historial completo de cambios está disponible en [CHANGELOG.md](./CHANGELOG.md).

---

## 10. Cómo desplegar

### Prerrequisitos

- Terraform >= 1.9.0 instalado
- AWS CLI configurado con credenciales válidas
- Par de claves SSH generado localmente

### Pasos

```bash
# 1. Clonar el repositorio
git clone https://github.com/carlcuevas/terraform-eft-cuevas.git
cd terraform-eft-cuevas

# 2. Inicializar Terraform
terraform init

# 3. Revisar el plan
terraform plan -var="public_key=$(cat ~/.ssh/id_rsa.pub)"

# 4. Aplicar la infraestructura
terraform apply -var="public_key=$(cat ~/.ssh/id_rsa.pub)"

# 5. Obtener la IP pública del servidor
terraform output instance_public_ip

# 6. Destruir la infraestructura cuando no se necesite
terraform destroy -var="public_key=$(cat ~/.ssh/id_rsa.pub)"
```

### Configurar secrets en GitHub

```
Repositorio → Settings → Secrets and variables → Actions → New repository secret

Agregar:
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_SESSION_TOKEN
```

---

## 11. Conclusiones

La solución presentada aborda de manera integral los desafíos identificados en las evaluaciones parciales 1, 2 y 3, cumpliendo con todos los requisitos técnicos establecidos:

**Calidad del código (EP1, EP2):**  
La implementación de TFLint con el plugin AWS y las reglas de convenciones garantiza un código limpio, consistente y bien documentado. El flujo de Pull Requests con validaciones automáticas asegura que ningún cambio de baja calidad pueda fusionarse a `main`.

**Seguridad (EP1):**  
Las tres políticas OPA actúan como un sistema de permisos automatizado que previene configuraciones inseguras antes del despliegue. Los cuatro escenarios de prueba validan tanto los casos de éxito como los de falla, garantizando la efectividad de las políticas.

**Modularidad y reutilización (EP2):**  
La arquitectura de tres módulos independientes (`networking`, `compute`, `storage`) permite desplegar cada componente de forma aislada o combinada, facilitando su integración en diferentes entornos sin modificaciones.

**Optimización y mantenibilidad (EP3):**  
Las validaciones integradas en variables, el uso de `default_tags`, la política de ciclo de vida en S3 y la estructura modular del código garantizan un proyecto eficiente, legible y fácil de mantener a largo plazo.

**Automatización CI/CD (EP1, EP2, EP3):**  
El pipeline de 5 etapas asegura un flujo de entrega continuo y eficiente, donde cada cambio es validado automáticamente antes de ser integrado, reduciendo el riesgo de errores en producción.

---

## 12. Anexos

### Repositorio GitHub

🔗 [https://github.com/carlcuevas/terraform-eft-cuevas](https://github.com/carlcuevas/terraform-eft-cuevas)

### Estructura del repositorio

```
terraform-eft-cuevas/
├── main.tf                          # Orquestación de módulos
├── variables.tf                     # Variables raíz
├── outputs.tf                       # Outputs raíz
├── terraform.tfvars                 # Valores por defecto
├── .tflint.hcl                      # Configuración TFLint
├── .gitignore                       # Exclusiones Git
├── CHANGELOG.md                     # Historial de versiones
├── README.md                        # Este informe
├── modules/
│   ├── networking/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── README.md
│   ├── compute/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── README.md
│   └── storage/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── README.md
├── policies/
│   ├── denegar_public_ssh.rego
│   ├── solo_t2_micro.rego
│   ├── denegar_s3_publico.rego
│   └── README.md
├── tests/
│   ├── plan-conforme.json
│   ├── plan-ssh-publico.json
│   ├── plan-tipo-invalido.json
│   ├── plan-s3-publico.json
│   └── README.md
└── .github/
    └── workflows/
        └── main.yml
```
