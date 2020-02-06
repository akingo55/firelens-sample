resource "aws_kinesis_firehose_delivery_stream" "firelens_log_stream" {
  destination = "s3"
  name        = "firelens_sample"


  s3_configuration {
    bucket_arn         = aws_s3_bucket.firelens_log_store.arn
    role_arn           = aws_iam_role.put_to_s3.arn
    buffer_size        = 1
    buffer_interval    = 60
    compression_format = "ZIP"
  }

}