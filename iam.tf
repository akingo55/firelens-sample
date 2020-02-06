data "aws_iam_policy" "AmazonECSTaskExecutionRolePolicy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy" "AmazonS3FullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role" "put_to_s3" {
  name = "sample_firehose_role_put_to_s3"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role" "put_to_firehose" {
  name = "sample_ecs_task_role_put_to_firehose"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  # Create role, but not use original name.
  name               = "sample_ecsTaskExecutionRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "put_to_firehose" {
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "firehose:PutRecordBatch",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "put_to_s3" {
  policy_arn = data.aws_iam_policy.AmazonS3FullAccess.arn
  role       = aws_iam_role.put_to_s3.name
}

resource "aws_iam_role_policy_attachment" "put_to_firehose" {
  policy_arn = aws_iam_policy.put_to_firehose.arn
  role       = aws_iam_role.put_to_firehose.name
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole" {
  policy_arn = data.aws_iam_policy.AmazonECSTaskExecutionRolePolicy.arn
  role       = aws_iam_role.ecsTaskExecutionRole.name
}
