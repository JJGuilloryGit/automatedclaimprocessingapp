resource "aws_ecr_repository" "app" {
  name                 = "${var.project_name}-${var.environment}-app"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  tags = { Name = "${var.project_name}-${var.environment}-ecr" }
}
