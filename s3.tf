data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "firelens_log_store" {
  bucket        = "firelens-test-${data.aws_caller_identity.current.account_id}"
  acl           = "private"
  force_destroy = true
}
