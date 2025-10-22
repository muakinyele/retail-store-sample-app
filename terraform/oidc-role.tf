# --------------------------------------------------
# OIDC Provider for GitHub Actions
# --------------------------------------------------
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]
}

# --------------------------------------------------
# IAM Role for GitHub Actions to Assume via OIDC
# --------------------------------------------------
data "aws_iam_policy_document" "github_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:your-github-org/your-repo-name:*"]
    }
  }
}

resource "aws_iam_role" "github_actions" {
  name               = "github-actions-oidc-role"
  assume_role_policy = data.aws_iam_policy_document.github_assume_role.json
}

# --------------------------------------------------
# IAM Policy (least privilege for Terraform deploys)
# --------------------------------------------------
data "aws_iam_policy_document" "github_policy" {
  statement {
    effect = "Allow"
    actions = [
      "eks:*",
      "iam:*",
      "ec2:*",
      "s3:*",
      "cloudwatch:*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "github_actions_policy" {
  name   = "github-actions-terraform-policy"
  policy = data.aws_iam_policy_document.github_policy.json
}

resource "aws_iam_role_policy_attachment" "github_attach" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions_policy.arn
}
