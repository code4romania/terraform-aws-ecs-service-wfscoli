variable "name" {
  description = "Instance name"
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,30}[a-z0-9]$", var.name))
    error_message = "Name must be between 3 and 32 characters long and only contain lowercase letters, numbers, and hyphens. It must start with a letter and end with a letter or number."
  }
}

variable "hostname" {
  description = "Custom hostname for the instance."
  type        = string
  default     = null
}

variable "admin_email" {
  description = "Email address of initial admin account"
  type        = string
  default     = "admin@wfscoli.ro"
}

variable "common" {
  description = "Common variables"
  type = object({
    image_tag                     = string
    namespace                     = string
    env                           = string
    rds_secrets_arn               = string
    create_database_function_name = string
    subdomain                     = string

    media = object({
      s3_bucket_name = string
      s3_bucket_arn  = string
      cloudfront_url = string
    })

    service_discovery = object({
      namespace_id = string
      arn          = string
    })

    ecs_cluster = object({
      name            = string
      arn             = string
      log_group_name  = string
      vpc_id          = string
      security_groups = list(string)
      network_subnets = list(string)
    })

    lb = object({
      dns_name     = string
      zone_id      = string
      listener_arn = string
    })

    apigateway_vpc_link_id = string
  })
}
