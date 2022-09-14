# prod-ci-role, prod-ci-policy, prod-ci-group, prod-ci-user

resource "aws_iam_user" "prod-ci-user" {
  name = "prod-ci-user"

  tags = {
    generatedBy = "terraform"
    environment = "production"
  }
}

resource "aws_iam_group" "prod-ci-group" {
  name = "developers"
}

resource "aws_iam_group_membership" "prod-ci-group" {
  name = "prod-ci-group"

  users = [
    aws_iam_user.prod-ci-user,
  ]

  group = aws_iam_group.prod-ci-group
}

resource "aws_iam_role" "prod-ci-role" {
  name = "prod-ci-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2022-09-14"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
      },
    ]
  })

  tags = {
    generatedBy = "terraform"
    environment = "production"
  }
}

resource "aws_iam_role_policy" "prod-ci-policy" {
  name        = "prod-ci-policy"
  role = aws_iam_role.prod-ci-role

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2022-09-14"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_group_policy_attachment" "prod-ci" {
  group      = aws_iam_group.prod-ci-group
  policy_arn = aws_iam_role_policy.prod-ci-policy
}
