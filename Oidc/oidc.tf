# Get TLS certificate for GitHub OIDC
data "tls_certificate" "eks" {
  url = "https://token.actions.githubusercontent.com"
}

# OIDC provider for GitHub Actions
resource "aws_iam_openid_connect_provider" "git" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = "https://token.actions.githubusercontent.com"
}

# IAM policy document for GitHub OIDC trust relationship
data "aws_iam_policy_document" "git_aws_oidc" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.git.url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "${replace(aws_iam_openid_connect_provider.git.url, "https://", "")}:sub"
      values   = ["repo:tanya-domi/*:*"]
    }

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.git.arn]
    }
  }
}

# IAM role for GitHub Actions
resource "aws_iam_role" "git_action" {
  name               = "git-action-role"
  assume_role_policy = data.aws_iam_policy_document.git_aws_oidc.json
}

# IAM policy with permissions (replace * with granular actions/resources if needed)
resource "aws_iam_policy" "git_action" {
  name = "git-actions-oidc"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["*"]
      Effect   = "Allow"
      Resource = "*"
    }]
  })
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "git_actions_oidc_attachment" {
  role       = aws_iam_role.git_action.name
  policy_arn = aws_iam_policy.git_action.arn
}

# Output IAM role ARN
output "git_action_oidc" {
  value = aws_iam_role.git_action.arn
}

provider "aws" {
  region = "eu-north-1"
}
