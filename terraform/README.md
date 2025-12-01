# Claim AI - Terraform (Test Environment)

This Terraform configuration deploys a minimal-cost test environment for the Claim AI Flask app:
- ECS Fargate service (small task: 256 CPU / 512 MB)
- ALB (HTTP)
- ECR repo
- S3 bucket for claims (auto-expire objects after 7 days)
- IAM roles for ECS tasks (Bedrock + Textract + S3 access)
- CloudWatch log group with 3-day retention

## Cost-minimizing choices
- Single public subnet to avoid NAT/GW charges
- Small Fargate task size (256/512)
- S3 lifecycle rule to expire objects after 7 days
- CloudWatch log retention = 3 days

## Usage

1. Initialize Terraform:
```bash
cd terraform
terraform init
```

2. Plan & Apply:
```bash
terraform plan -out=tfplan
terraform apply tfplan
```

3. Build and push a small Docker image to ECR:
```bash
# get ECR URL from terraform output
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com
docker build -t claim-ai-app:latest .
docker tag claim-ai-app:latest <ECR_REPO_URL>:latest
docker push <ECR_REPO_URL>:latest
```

4. Once pushed, ECS will pull the image. Check the ALB DNS name from terraform outputs.

## Tear down
To avoid costs, destroy the stack when done:
```bash
terraform destroy -auto-approve
```
