# --------------------------------------------------
# Developer Read-only IAM User
# --------------------------------------------------
resource "aws_iam_user" "dev_readonly_user" {
  name = "innovatemart-dev-readonly"

  tags = {
    Team = "dev"
  }

  lifecycle {
    prevent_destroy = true
  }
}

# --------------------------------------------------
# Policy Document granting read-only access to EKS, CloudWatch, and Logs
# --------------------------------------------------
data "aws_iam_policy_document" "dev_readonly_policy" {
  statement {
    sid    = "ReadOnlyEKS"
    effect = "Allow"

    actions = [
      "eks:Describe*",
      "eks:List*",
      "eks:Get*",
      "logs:Describe*",
      "logs:Get*",
      "logs:List*",
      "ec2:Describe*",
      "iam:List*",
      "iam:Get*",
      "cloudwatch:Get*",
      "cloudwatch:List*",
      "cloudwatch:Describe*"
    ]

    resources = ["*"]
  }
}

# --------------------------------------------------
# Attach inline policy to the IAM user
# --------------------------------------------------
resource "aws_iam_user_policy" "dev_readonly_inline" {
  name   = "innovatemart-dev-readonly-policy"
  user   = aws_iam_user.dev_readonly_user.name
  policy = data.aws_iam_policy_document.dev_readonly_policy.json

  lifecycle {
    prevent_destroy = true
  }
}

# --------------------------------------------------
# (Optional) Access Key for developer (if required)
# --------------------------------------------------
# NOTE: Only create this if devs need programmatic access.
resource "aws_iam_access_key" "dev_readonly_key" {
  user = aws_iam_user.dev_readonly_user.name

  lifecycle {
    prevent_destroy = true
  }
}
