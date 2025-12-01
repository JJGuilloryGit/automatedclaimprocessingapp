output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.alb.dns_name
}

output "ecr_repo_url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.app.repository_url
}

output "s3_bucket" {
  description = "S3 bucket name for claims"
  value       = aws_s3_bucket.claims_bucket.bucket
}

output "ecs_cluster" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.this.name
}
