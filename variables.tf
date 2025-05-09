variable "name" {
  description = "Instance name"
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,13}[a-z0-9]$", var.name))
    error_message = "Name must be between 3 and 15 characters long and only contain lowercase letters, numbers, and hyphens. It must start with a letter and end with a letter or number."
  }
}

variable "hostname" {
  description = "Custom hostname for the instance."
  type        = string
  default     = null
}


variable "common" {
  description = "Common variables"
  type = object({
    namespace                     = string
    env                           = string
    rds_secrets_arn               = string
    create_database_function_name = string
    subdomain                     = string
    image_tag                     = string

    media = object({
      s3_bucket_name = string
      s3_bucket_arn  = string
      cloudfront_url = string
    })

    ecs_cluster = object({
      cluster_name                   = string
      log_group_name                 = string
      service_discovery_namespace_id = string
      security_groups                = list(string)
      network_subnets                = list(string)
    })

    # lb = object({
    #   dns_name     = string
    #   zone_id      = string
    #   listener_arn = string
    # })
  })
}
