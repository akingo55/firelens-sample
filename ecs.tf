resource "aws_ecs_cluster" "main" {
  name = "firelens_sample_cluster"
}

resource "aws_ecs_task_definition" "firelens_sample" {
  container_definitions    = file("./template/taskdef.json")
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.put_to_firehose.arn
  family                   = "firelens_sample"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = "256"
  memory = "512"
}

resource "aws_ecs_service" "firelens_sample" {
  name            = "firelens_sample"
  launch_type     = "FARGATE"
  cluster         = aws_ecs_cluster.main.name
  task_definition = aws_ecs_task_definition.firelens_sample.arn
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.public_c.id, aws_subnet.public_a.id]
    security_groups  = [aws_security_group.outbound_only.id]
    assign_public_ip = true
  }
}

