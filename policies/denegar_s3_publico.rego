package terraform.policies

# =============================================================================
# Política: Denegar buckets S3 con acceso público habilitado
# -----------------------------------------------------------------------------
# Objetivo:
#   Garantizar que ningún bucket S3 tenga el bloqueo de acceso público
#   desactivado, previniendo exposición accidental de datos sensibles.
#
# Criterio de denegación:
#   Recurso de tipo aws_s3_bucket_public_access_block donde cualquiera
#   de las 4 configuraciones de bloqueo esté en false.
#
# Indicador evaluado: IL2.1, IL2.2, IL2.3
# Compatibilidad: Rego v1 (OPA >= 1.0)
# =============================================================================

deny contains msg if {
    resource := input.resource_changes[_]
    resource.type == "aws_s3_bucket_public_access_block"
    resource.change.after.block_public_acls == false

    msg := sprintf(
        "VIOLACION DE SEGURIDAD [IL2.1]: El bucket '%s' tiene 'block_public_acls' desactivado. Todos los bloqueos públicos deben estar en true.",
        [resource.address],
    )
}

deny contains msg if {
    resource := input.resource_changes[_]
    resource.type == "aws_s3_bucket_public_access_block"
    resource.change.after.block_public_policy == false

    msg := sprintf(
        "VIOLACION DE SEGURIDAD [IL2.1]: El bucket '%s' tiene 'block_public_policy' desactivado. Todos los bloqueos públicos deben estar en true.",
        [resource.address],
    )
}

deny contains msg if {
    resource := input.resource_changes[_]
    resource.type == "aws_s3_bucket_public_access_block"
    resource.change.after.restrict_public_buckets == false

    msg := sprintf(
        "VIOLACION DE SEGURIDAD [IL2.1]: El bucket '%s' tiene 'restrict_public_buckets' desactivado. Todos los bloqueos públicos deben estar en true.",
        [resource.address],
    )
}
