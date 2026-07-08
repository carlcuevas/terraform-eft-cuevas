# Guía de Presentación Oral
## Evaluación Final Transversal — AUY1105
### Infraestructura como Código II
**Estudiante:** Carlos Cuevas  
**Tiempo:** 10 minutos (5 exposición + 5 preguntas)

---

# PARTE 1 — GUÍA DE EXPOSICIÓN (5 minutos)

---

## ⏱️ Minuto 0:00 — 0:30 | INTRODUCCIÓN

**Qué decir:**
> *"Buenos días/tardes. Mi proyecto es el consolidado final de las evaluaciones parciales 1, 2 y 3 de la asignatura Infraestructura como Código II. Implementé una solución completa de infraestructura en AWS utilizando Terraform, organizada en módulos reutilizables, con políticas de seguridad automatizadas usando OPA, y un pipeline CI/CD de 5 etapas en GitHub Actions."*

**Qué mostrar:**
- Abrir el repositorio: https://github.com/carlcuevas/terraform-eft-cuevas
- Mostrar la página principal con la estructura de carpetas

---

## ⏱️ Minuto 0:30 — 1:30 | ARQUITECTURA Y MÓDULOS (IL3.1, IL3.2)

**Qué decir:**
> *"La solución está organizada en 3 módulos independientes y reutilizables. El módulo networking crea la VPC, subnet pública, internet gateway y security group. El módulo compute crea la instancia EC2 t2.micro con una Elastic IP. Y el módulo storage crea el bucket S3 con cifrado, versionado y control de acceso público. Cada módulo tiene su propio README con tabla de parámetros, ejemplos de uso y documentación de outputs."*

**Qué mostrar:**
- Click en `modules/` → mostrar las 3 carpetas
- Abrir `main.tf` raíz → mostrar cómo los 3 módulos se conectan
- Señalar la línea donde `compute` recibe `subnet_id` de `networking`
- Abrir `modules/networking/README.md` → mostrar tabla de parámetros

**Puntos clave a destacar:**
- Los módulos son **independientes**: storage no depende de networking
- Los módulos son **reutilizables**: se pueden usar en otros proyectos
- Cada módulo tiene **validaciones integradas** en las variables

---

## ⏱️ Minuto 1:30 — 2:30 | POLÍTICAS DE SEGURIDAD OPA (IL2.1, IL2.2, IL2.3)

**Qué decir:**
> *"Para garantizar la seguridad de la infraestructura implementé 3 políticas OPA. La primera bloquea cualquier Security Group que exponga el puerto SSH al mundo. La segunda restringe las instancias EC2 exclusivamente al tipo t2.micro. La tercera impide que los buckets S3 tengan acceso público habilitado. Estas políticas se evalúan automáticamente en el pipeline antes de cualquier despliegue."*

**Qué mostrar:**
- Abrir `policies/denegar_public_ssh.rego` → leer el bloque `deny`
- Mostrar el mensaje de error que genera: `"VIOLACION DE SEGURIDAD [IL2.1]..."`
- Abrir `tests/README.md` → mostrar la tabla de 4 escenarios de prueba

**Puntos clave a destacar:**
- La infraestructura tiene **2 capas de seguridad**: validación en variables Terraform + política OPA
- Las políticas se alinean con el **CIS AWS Foundations Benchmark**
- Los 4 escenarios de prueba validan tanto casos de éxito como de falla

---

## ⏱️ Minuto 2:30 — 3:30 | PIPELINE CI/CD (IL1.1, IL1.2, IL2.2)

**Qué decir:**
> *"El pipeline CI/CD tiene 5 etapas que se ejecutan automáticamente en cada Pull Request. Primero TFLint analiza la calidad del código. Segundo Checkov analiza la seguridad de la infraestructura. Tercero terraform validate verifica la sintaxis. Cuarto OPA evalúa las 3 políticas de seguridad con 4 escenarios de prueba. Y quinto terraform plan genera el reporte de cambios. Si cualquier etapa falla, el PR queda bloqueado."*

**Qué mostrar:**
- Abrir: https://github.com/carlcuevas/terraform-eft-cuevas/actions/runs/28976768351
- Mostrar todas las etapas con ✅ verde
- Click en `[Etapa 2] Checkov` → mostrar `21 passed, 0 failed`
- Click en `[Etapa 4] Validar escenarios OPA` → mostrar las 4 pruebas superadas

**Puntos clave a destacar:**
- El pipeline **bloquea el merge** si algo falla
- Se ejecuta en **cada Pull Request** automáticamente
- El historial muestra **6 runs**: 4 fallidos corregidos y 2 exitosos

---

## ⏱️ Minuto 3:30 — 4:00 | PULL REQUEST Y REVISIÓN DE CÓDIGO (IL1.1)

**Qué decir:**
> *"Todo el trabajo se realizó mediante Pull Requests. El PR #1 tiene una descripción detallada de todos los cambios incluidos. El historial de commits muestra el proceso de mejora continua: primero el trigger inicial, luego correcciones a TFLint, Checkov y el formato. Esto demuestra el flujo de desarrollo profesional con revisión de código."*

**Qué mostrar:**
- Abrir: https://github.com/carlcuevas/terraform-eft-cuevas/pull/1
- Mostrar badge **"Merged"** en morado
- Mostrar los **4 commits** con mensajes descriptivos
- Mostrar el check **"All checks passed"**

---

## ⏱️ Minuto 4:00 — 5:00 | VERSIONADO SEMÁNTICO Y CIERRE (IL3.3)

**Qué decir:**
> *"El proyecto usa versionado semántico con 4 versiones que documentan la evolución del proyecto. v1.0.0 fue la infraestructura base del EP1. v2.0.0 fue la refactorización a módulos del EP2, que es un MAJOR bump porque cambió la estructura completamente. v2.1.0 fue la gestión avanzada del estado del EP3. Y v3.0.0 es este consolidado final con nuevas políticas y optimizaciones. Para concluir, la solución cubre todos los indicadores de logro: calidad de código, seguridad, modularidad, documentación y automatización."*

**Qué mostrar:**
- Abrir `CHANGELOG.md` → mostrar las 4 versiones
- Terminar volviendo a la página principal del repo

---

# PARTE 2 — PREGUNTAS DEL DOCENTE (5 minutos)

---

## 🔴 PREGUNTA 1 — IL1.2 (20% de la presentación)
### *"¿Qué diferencia hay entre TFLint y Checkov? ¿Por qué usas los dos?"*

**Respuesta completa:**
> *"Son herramientas complementarias que cubren aspectos diferentes. TFLint analiza la **calidad y estructura del código Terraform**: verifica que los nombres sigan la convención snake_case, que todas las variables tengan descripción, que la versión de Terraform y del proveedor estén declaradas, y que los tipos de instancia EC2 sean válidos en AWS. Es como un linter de código.*
>
> *Checkov en cambio analiza la **seguridad de la infraestructura que el código va a crear**: verifica que el bucket S3 tenga cifrado habilitado, que el versionado esté activo, que el Block Public Access esté configurado, que el Security Group no exponga puertos peligrosos. Es un escáner de seguridad.*
>
> *Los uso juntos porque TFLint cuida el código y Checkov cuida la infraestructura. En mi proyecto TFLint pasó sin errores y Checkov pasó 21 checks con 0 fallidos."*

**Evidencia a mostrar:** Cap 2 (TFLint) y Cap 3 (Checkov 21 passed)

---

## 🔴 PREGUNTA 2 — IL3.1 (20% de la presentación)
### *"¿Por qué dividiste en 3 módulos? ¿Qué beneficio tiene?"*

**Respuesta completa:**
> *"La modularidad tiene 3 beneficios principales. Primero, **reutilización**: el módulo networking puede usarse en otro proyecto sin tocar nada más. Segundo, **separación de responsabilidades**: si necesito cambiar algo del almacenamiento S3, solo modifico el módulo storage sin afectar la red ni el cómputo. Tercero, **independencia**: el módulo storage no depende de ningún otro módulo, se puede desplegar solo.*
>
> *La conexión entre módulos se hace a través de outputs. El módulo compute recibe el subnet_id y el security_group_id como parámetros desde los outputs del módulo networking. Esto es lo que hace la arquitectura flexible y mantenible.*
>
> *Cada módulo además tiene validaciones propias. Por ejemplo, el módulo networking tiene una validación que impide configurar ssh_allowed_cidr con 0.0.0.0/0, y el módulo compute solo acepta instance_type t2.micro."*

**Evidencia a mostrar:** Cap 11 (estructura repo) y Cap 12 (main.tf con 3 módulos)

---

## 🔴 PREGUNTA 3 — IL2.1 (10% de la presentación)
### *"¿Con qué norma o estándar se alinean tus políticas OPA?"*

**Respuesta completa:**
> *"Las 3 políticas se alinean con estándares reconocidos de la industria.*
>
> *La política de SSH se alinea con el **CIS AWS Foundations Benchmark**, específicamente el control 5.2 que establece que ningún Security Group debe permitir acceso irrestricto al puerto 22 desde internet.*
>
> *La política de t2.micro se alinea con el **AWS Well-Architected Framework**, pilar de Optimización de Costos, que recomienda usar el tipo de instancia mínimo necesario para el workload.*
>
> *La política de S3 público se alinea con el **CIS AWS Foundations Benchmark** control 2.1.5, que establece que todos los buckets S3 deben tener el Block Public Access habilitado para prevenir exposición accidental de datos.*
>
> *Estas políticas actúan como sistema de permisos automatizado: si alguien intenta hacer un cambio que viole estas normas, el pipeline bloquea el PR automáticamente."*

**Evidencia a mostrar:** Cap 15 (denegar_public_ssh.rego) y Cap 5 (OPA resultado [])

---

## 🔴 PREGUNTA 4 — IL3.3 (10% de la presentación)
### *"¿Por qué la versión actual es 3.0.0? Explica el versionado semántico"*

**Respuesta completa:**
> *"El versionado semántico usa el formato MAJOR.MINOR.PATCH. MAJOR sube cuando hay cambios incompatibles con versiones anteriores. MINOR sube cuando se agrega funcionalidad compatible. PATCH sube cuando solo se corrigen errores.*
>
> *v1.0.0 fue la versión inicial del EP1 con la infraestructura base y el pipeline.*
>
> *v2.0.0 fue el EP2: subí el MAJOR porque refactoricé completamente la arquitectura monolítica a módulos. Esto es un breaking change porque los nombres de los recursos en el estado de Terraform cambiaron, requiriendo terraform state mv para migrar.*
>
> *v2.1.0 fue el EP3: subí el MINOR porque agregué gestión avanzada del estado con terraform import, refresh, taint y state rm. Esto es funcionalidad nueva compatible con v2.0.0.*
>
> *v3.0.0 es la EFT: subí el MAJOR porque consolidé todo con una nueva política OPA, nueva etapa en el pipeline, y cambios en los módulos que agregan recursos nuevos como la Elastic IP y el lifecycle de S3."*

**Evidencia a mostrar:** Cap 18 (CHANGELOG con 4 versiones)

---

## 🔴 PREGUNTA 5 — IL3.2 (10% de la presentación)
### *"¿Qué incluye la documentación de cada módulo?"*

**Respuesta completa:**
> *"Cada módulo tiene su propio archivo README.md con 6 secciones. Primero una descripción general de qué hace el módulo. Segundo un ejemplo de uso completo en HCL que se puede copiar y pegar directamente. Tercero una tabla de todos los parámetros configurables con su tipo, valor por defecto y descripción. Cuarto una tabla de todos los outputs que expone el módulo. Quinto notas de seguridad específicas del módulo, por ejemplo el módulo networking documenta que ssh_allowed_cidr nunca debe ser 0.0.0.0/0. Y sexto las dependencias con otros módulos.*
>
> *Esta documentación cumple con el indicador IL3.2 que pide documentación completa y clara incluyendo ejemplos prácticos, descripciones detalladas de parámetros y dependencias."*

**Evidencia a mostrar:** Cap 14 (modules/networking/README.md)

---

## 🟡 PREGUNTA EXTRA — Por si el docente pregunta sobre el EP3
### *"¿Qué comandos de gestión de estado usaste en el EP3?"*

**Respuesta completa:**
> *"En el EP3 trabajé con 3 escenarios de gestión del estado. En el primer escenario simulé la pérdida del estado y lo recuperé usando terraform import para reimportar los 4 recursos: la VPC, la subnet, el security group y la instancia EC2.*
>
> *En el segundo escenario usé terraform refresh para sincronizar el estado con la realidad de AWS cuando hay diferencias, y terraform taint para marcar un recurso como que necesita ser recreado en el próximo apply.*
>
> *En el tercer escenario usé terraform state rm para eliminar el Security Group del archivo de estado sin destruirlo en AWS, lo que permite que Terraform deje de gestionar ese recurso sin afectar la infraestructura real.*
>
> *Estos comandos están documentados en el CHANGELOG v2.1.0."*

---

## 🟡 PREGUNTA EXTRA — Por si el docente pregunta sobre el pipeline fallido
### *"¿Por qué el pipeline falló las primeras 4 veces?"*

**Respuesta completa:**
> *"Eso es parte del proceso de mejora continua que evidencia el indicador IL1.1. El Run #1 falló porque TFLint detectó que los módulos no tenían el bloque terraform con required_version y required_providers declarados. Lo corregí agregando ese bloque a los 3 módulos.*
>
> *El Run #3 falló porque Checkov detectó 6 configuraciones que no cumplían sus checks predeterminados, como el S3 sin replicación cross-region o el Security Group sin adjuntar a un recurso en el mismo archivo. Los agregué al skip_check porque están fuera del scope del proyecto.*
>
> *El Run #4 falló porque terraform fmt detectó que el archivo terraform.tfvars no tenía el formato correcto de alineación. Lo corregí ejecutando terraform fmt localmente.*
>
> *El Run #5 pasó todas las etapas y fue el que se mergeó a main. Este historial demuestra que el pipeline funciona correctamente como sistema de control de calidad."*

**Evidencia a mostrar:** Tabla de historial de ejecuciones en EVIDENCIAS.md

---

# PARTE 3 — CHECKLIST ANTES DE LA PRESENTACIÓN

---

## 📋 10 minutos antes

- [ ] Abrir el repositorio: https://github.com/carlcuevas/terraform-eft-cuevas
- [ ] Abrir el Run #5: https://github.com/carlcuevas/terraform-eft-cuevas/actions/runs/28976768351
- [ ] Abrir el PR #1: https://github.com/carlcuevas/terraform-eft-cuevas/pull/1
- [ ] Abrir CHANGELOG.md en el repo
- [ ] Tener esta guía visible en otra pantalla o impresa
- [ ] Verificar conexión a internet

## 📂 Pestañas del navegador a tener abiertas

| Pestaña | URL |
|---|---|
| 1 — Repo principal | https://github.com/carlcuevas/terraform-eft-cuevas |
| 2 — Run #5 pipeline | https://github.com/carlcuevas/terraform-eft-cuevas/actions/runs/28976768351 |
| 3 — PR #1 | https://github.com/carlcuevas/terraform-eft-cuevas/pull/1 |
| 4 — main.tf | https://github.com/carlcuevas/terraform-eft-cuevas/blob/main/main.tf |
| 5 — OPA policy | https://github.com/carlcuevas/terraform-eft-cuevas/blob/main/policies/denegar_public_ssh.rego |
| 6 — CHANGELOG | https://github.com/carlcuevas/terraform-eft-cuevas/blob/main/CHANGELOG.md |

## 🎯 Frases clave para recordar

| Concepto | Frase clave |
|---|---|
| TFLint vs Checkov | *"TFLint cuida el código, Checkov cuida la infraestructura"* |
| Módulos | *"Independientes, reutilizables, con validaciones propias"* |
| OPA | *"Sistema de permisos automatizado alineado con CIS AWS"* |
| Versionado | *"MAJOR cuando hay breaking changes, MINOR cuando agrego funcionalidad"* |
| Pipeline | *"5 etapas, bloquea el PR si algo falla, evidencia mejora continua"* |

---

# PARTE 4 — MAPA DE INDICADORES vs EVIDENCIAS

| Indicador | % Presentación | Pregunta probable | Evidencia a mostrar |
|---|---|---|---|
| IL1.2 | 20% | TFLint vs Checkov | Cap 2 + Cap 3 |
| IL3.1 | 20% | Por qué 3 módulos | Cap 11 + Cap 12 |
| IL2.1 | 10% | Normas OPA | Cap 15 + Cap 5 |
| IL3.2 | 10% | Documentación módulos | Cap 14 |
| IL3.3 | 10% | Versionado semántico | Cap 18 |
