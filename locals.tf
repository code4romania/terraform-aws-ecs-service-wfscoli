locals {
  hosts = compact([
    var.hostname,
    "${var.name}.${var.common.subdomain}",
  ])
}
