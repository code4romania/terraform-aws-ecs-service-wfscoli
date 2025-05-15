locals {
  default_host = "${var.name}.${var.common.subdomain}"

  hosts = compact([
    var.hostname,
    local.default_host,
  ])
}
