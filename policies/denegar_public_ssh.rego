package terraform.policies

# =============================================================================
# Política: Denegar acceso SSH público
# -----------------------------------------------------------------------------
# Objetivo:
#   Impedir que cualquier Security Group exponga el puerto 22 (SSH) al
#   bloque 0.0.0.0/0 (toda internet), lo que constituye una vulnerabilidad
#   crítica de exposición perimetral.
#
# Criterio de denegación:
#   Recurso de tipo aws_security_group con una regla de ingress donde:
#     - from_port <= 22 <= to_port
#     - cidr_blocks contenga "0.0.0.0/0"
#
# Indicador evaluado: IL2.1, IL2.2, IL2.3
# Compatibilidad: Rego v1 (OPA >= 1.0)
# =============================================================================

deny contains msg if {
    resource := input.resource_changes[_]
    resource.type == "aws_security_group"
    ingress := resource.change.after.ingress[_]
    ingress.from_port <= 22
    ingress.to_port >= 22
    ingress.cidr_blocks[_] == "0.0.0.0/0"

    msg := sprintf(
        "VIOLACION DE SEGURIDAD [IL2.1]: El Security Group '%s' expone el puerto SSH (22) a 0.0.0.0/0. Restrinja el acceso a un CIDR específico.",
        [resource.address],
    )
}
