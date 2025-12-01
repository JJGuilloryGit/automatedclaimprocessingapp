# Automated Claim & Patient Case Processing on AWS

A complete AWS infrastructure setup for deploying a Claim AI Flask application using Terraform and ECS Fargate.

## 🏗️ Architecture

- **ECS Fargate** - Containerized Flask app (256 CPU / 512 MB)
- **Application Load Balancer** - HTTP traffic routing
- **ECR Repository** - Docker image storage
- **S3 Bucket** - Claims document storage (7-day auto-expire)
- **IAM Roles** - Bedrock, Textract, and S3 access
- **CloudWatch** - Logging with 3-day retention

## 🚀 Quick Start

1. **Deploy Infrastructure**:
   ```bash
   cd terraform
   terraform init
   terraform apply
   ```

2. **Build & Deploy App**:
   ```bash
   # Login to ECR
   aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $(terraform output -raw ecr_repo_url | cut -d'/' -f1)
   
   # Build and push
   docker build -t claim-ai-app:latest .
   docker tag claim-ai-app:latest $(terraform output -raw ecr_repo_url):latest
   docker push $(terraform output -raw ecr_repo_url):latest
   ```

3. **Access App**:
   ```bash
   echo "App URL: http://$(terraform output -raw alb_dns_name)"
   ```

## 📱 Features

- **File Upload** - PDF, PNG, JPG support
- **Claim Processing** - AI-powered document analysis
- **Web Interface** - Clean HTML frontend
- **Health Checks** - ALB health monitoring

## 💰 Cost Optimization

- Single public subnet (no NAT Gateway costs)
- Minimal Fargate task size
- S3 lifecycle rules (7-day expiration)
- Short CloudWatch retention (3 days)

## 🧹 Cleanup

```bash
terraform destroy -auto-approve
```

## 📁 Project Structure

```
├── terraform/          # Infrastructure as Code
├── app.py              # Flask application
├── requirements.txt    # Python dependencies
├── Dockerfile         # Container definition
└── README.md          # This file
```
