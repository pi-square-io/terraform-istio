
resource "helm_release" "helm" {
  name             = var.name
  repository       = var.repository
  chart            = var.chart
  create_namespace = var.create_namespace
  namespace        = var.namespace
  version          = var.release_version

  # dynamic "set" {
  #   for_each = var.set
  #   content {
  #     name  = lookup(set.value, "name", null)
  #     value = lookup(set.value, "value", null)
  #   }
  # }
}
