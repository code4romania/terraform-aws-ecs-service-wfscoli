resource "aws_apigatewayv2_api" "main" {
  name          = var.name
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_vpc_link" "main" {
  name               = "${var.name}-vpc-link"
  security_group_ids = [aws_security_group.gateway_vpclink.id]
  subnet_ids         = var.common.ecs_cluster.network_subnets
}

resource "aws_apigatewayv2_integration" "main" {
  api_id                 = aws_apigatewayv2_api.main.id
  integration_type       = "HTTP_PROXY"
  integration_method     = "ANY"
  connection_type        = "VPC_LINK"
  connection_id          = aws_apigatewayv2_vpc_link.main.id
  integration_uri        = var.common.service_discovery.arn
  payload_format_version = "1.0"
  description            = "${var.name} CloudMap Integration"
}

resource "aws_apigatewayv2_route" "main" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "ANY /"
  target    = "integrations/${aws_apigatewayv2_integration.main.id}"
}

resource "aws_apigatewayv2_stage" "main" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_security_group" "gateway_vpclink" {
  name        = "${var.name}-gateway-vpc-link"
  description = "Security group for API Gateway VPC Link"
  vpc_id      = var.common.ecs_cluster.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "allow_vpclink_to_ecs" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = var.common.ecs_cluster.security_groups[0]
  source_security_group_id = aws_security_group.gateway_vpclink.id
}
