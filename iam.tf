resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.common.namespace}-${var.name}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json
}

data "aws_iam_policy_document" "ecs_task_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "ecs_task_policy" {
  name   = "${var.common.namespace}-${var.name}-ecs-task-policy"
  role   = aws_iam_role.ecs_task_role.id
  policy = data.aws_iam_policy_document.ecs_task_policy.json
}

data "aws_iam_policy_document" "ecs_task_policy" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:HeadBucket"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:GetObjectAcl",
      "s3:PutObjectAcl",
      "s3:PutObject"
    ]

    resources = [
      var.common.media.s3_bucket_arn,
      "${var.common.media.s3_bucket_arn}/${var.name}/*"
    ]
  }
}

resource "aws_iam_role_policies_exclusive" "ecs_task" {
  role_name    = aws_iam_role.ecs_task_role.name
  policy_names = [aws_iam_role_policy.ecs_task_policy.name]
}
