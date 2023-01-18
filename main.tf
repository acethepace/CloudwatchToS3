data "aws_caller_identity" "current" {}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "earnin-prod-us-west-2-logs-${data.aws_caller_identity.current.account_id}"
}

resource "aws_cloudwatch_log_group" "pci-eks-cluster-logs" {
  name = "/aws/eks/pci-eks/cluster"
}

resource "aws_cloudwatch_log_group" "eks-cluster-logs" {
  name = "/aws/eks/eks-cluster/cluster"
}

resource "aws_kinesis_firehose_delivery_stream" "log_stream" {
  name        = "earnin-prod-us-west-2-logs-stream"
  destination = "s3"

  s3_configuration {
    bucket_arn = aws_s3_bucket.log_bucket.arn
    prefix     = "AWSlogs/${data.aws_caller_identity.current.account_id}"
    role_arn   = aws_iam_role.firehose_delivery_role.arn
  }
}

resource "aws_cloudwatch_log_subscription_filter" "pci_eks_cluster_log_export_task" {
  name            = "pci_eks_cluster_log_export_task"
  log_group_name  = aws_cloudwatch_log_group.pci-eks-cluster-logs.name
  destination_arn = aws_kinesis_firehose_delivery_stream.log_stream.arn
  filter_pattern  = ""
  role_arn        = aws_iam_role.cloudwatch_to_firehose_role.arn
}

resource "aws_cloudwatch_log_subscription_filter" "eks_cluster_log_export_task2" {
  name            = "eks_cluster_log_export_task2"
  log_group_name  = aws_cloudwatch_log_group.eks-cluster-logs.name
  destination_arn = aws_kinesis_firehose_delivery_stream.log_stream.arn
  filter_pattern  = ""
  role_arn        = aws_iam_role.cloudwatch_to_firehose_role.arn
}
