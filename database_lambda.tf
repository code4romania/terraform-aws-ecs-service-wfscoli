resource "aws_lambda_invocation" "create_database" {
  function_name   = var.common.create_database_function_name
  input           = jsonencode({ database = var.name })
  lifecycle_scope = "CREATE_ONLY"
}
