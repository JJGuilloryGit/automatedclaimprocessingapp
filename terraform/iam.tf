data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.project_name}-${var.environment}-ecs-exec-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_managed" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.project_name}-${var.environment}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

data "aws_iam_policy_document" "ecs_task_policy" {
  statement {
    sid = "S3Access"
    actions = ["s3:PutObject","s3:GetObject","s3:ListBucket"]
    resources = [ aws_s3_bucket.claims_bucket.arn, "${aws_s3_bucket.claims_bucket.arn}/*" ]
  }

  statement {
    sid = "TextractAccess"
    actions = [
      "textract:StartDocumentTextDetection",
      "textract:GetDocumentTextDetection",
      "textract:StartDocumentAnalysis",
      "textract:GetDocumentAnalysis",
      "textract:DetectDocumentText",
      "textract:AnalyzeDocument"
    ]
    resources = ["*"]
  }

  statement {
    sid = "BedrockInvoke"
    actions = [
      "bedrock:InvokeModel",
      "bedrock:InvokeModelWithResponseStream"
    ]
    resources = ["*"]
  }

  statement {
    sid = "Logs"
    actions = ["logs:CreateLogStream","logs:PutLogEvents","logs:CreateLogGroup"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "ecs_task_inline" {
  name = "${var.project_name}-${var.environment}-ecs-task-inline"
  role = aws_iam_role.ecs_task_role.id
  policy = data.aws_iam_policy_document.ecs_task_policy.json
}
