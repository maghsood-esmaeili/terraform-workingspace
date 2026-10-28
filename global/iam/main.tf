provider "aws" {
  region = "us-east-1"

}

resource "aws_iam_policy" "cloudwatch_read_only" {
  count  = var.give_neo_cloudwatch_full_access ? 0 : 1
  name   = "cloudwatch-read-only"
  policy = data.aws_iam_policy_document.cloudwatch_read_only.json
}
data "aws_iam_policy_document" "cloudwatch_read_only" {
  statement {
    effect = "Allow"
    actions = [
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*"
    ]

    resources = ["*"]
  }

}
resource "aws_iam_policy" "cloudwatch_full_access" {
  count  = var.give_neo_cloudwatch_full_access ? 1 : 0
  name   = "cloudwatch-full-access"
  policy = data.aws_iam_policy_document.cloudwatch_full_access.json
}
data "aws_iam_policy_document" "cloudwatch_full_access" {
  statement {
    effect    = "Allow"
    actions   = ["cloudwatch:*"]
    resources = ["*"]
  }

}

