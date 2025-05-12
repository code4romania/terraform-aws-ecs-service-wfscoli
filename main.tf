module "ecs_app" {
  source  = "code4romania/ecs-service/aws"
  version = "0.1.3"

  namespace    = var.name
  cluster_name = var.common.ecs_cluster.cluster_name
  min_capacity = 1
  max_capacity = 1

  image_repo = "code4romania/website-factory"
  image_tag  = var.common.image_tag

  # use_load_balancer       = true
  # lb_dns_name             = var.common.lb.dns_name
  # lb_zone_id              = var.common.lb.zone_id
  # lb_vpc_id               = aws_vpc.main.id
  # lb_listener_arn         = var.common.lb.listener_arn
  # lb_hosts                = local.hosts
  # lb_health_check_enabled = true
  # lb_path                 = "/up"

  container_memory_hard_limit = 512

  log_group_name                 = var.common.ecs_cluster.log_group_name
  service_discovery_namespace_id = var.common.service_discovery.namespace_id

  container_port          = 80
  network_mode            = "awsvpc"
  network_security_groups = var.common.ecs_cluster.security_groups
  network_subnets         = var.common.ecs_cluster.network_subnets

  task_role_arn = aws_iam_role.ecs_task_role.arn

  ordered_placement_strategy = [
    {
      type  = "spread"
      field = "instanceId"
    },
    {
      type  = "binpack"
      field = "memory"
    }
  ]

  environment = [
    {
      name  = "WEBSITE_FACTORY_EDITION"
      value = "school"
    },
    {
      name  = "APP_ENV"
      value = var.common.env
    },
    {
      name  = "APP_URL"
      value = "https://${local.hosts[0]}"
    },
    {
      name  = "DB_DATABASE"
      value = var.name
    },
    {
      name  = "MAIL_MAILER"
      value = "ses"
    },
    {
      name  = "MAIL_FROM_ADDRESS"
      value = "${var.name}@${var.common.subdomain}"
    },
    {
      name  = "FILESYSTEM_DRIVER"
      value = "s3"
    },
    {
      name  = "FILESYSTEM_CLOUD"
      value = "s3"
    },
    {
      name  = "AWS_DEFAULT_REGION"
      value = data.aws_region.current.name
    },
    {
      name  = "AWS_BUCKET"
      value = var.common.media.s3_bucket_name
    },
    {
      name  = "AWS_URL"
      value = "https://${var.common.media.cloudfront_url}"
    },
    {
      name  = "SENTRY_ENVIRONMENT"
      value = "${var.name}-${var.common.subdomain}"
    },
    {
      name  = "SENTRY_TRACES_SAMPLE_RATE"
      value = 0.3
    },
    {
      name  = "SENTRY_PROFILES_SAMPLE_RATE"
      value = 0.5
    },
    {
      name  = "PHP_PM_MAX_CHILDREN",
      value = 128
    },
  ]

  secrets = [
    {
      name      = "APP_KEY"
      valueFrom = aws_secretsmanager_secret.app_key.arn
    },
    {
      name      = "DB_HOST"
      valueFrom = "${var.common.rds_secrets_arn}:host::"
    },
    {
      name      = "DB_PORT"
      valueFrom = "${var.common.rds_secrets_arn}:port::"
    },
    {
      name      = "DB_USERNAME"
      valueFrom = "${var.common.rds_secrets_arn}:username::"
    },
    {
      name      = "DB_PASSWORD"
      valueFrom = "${var.common.rds_secrets_arn}:password::"
    },
  ]

  allowed_secrets = [
    aws_secretsmanager_secret.app_key.arn,
    var.common.rds_secrets_arn,
  ]
}
