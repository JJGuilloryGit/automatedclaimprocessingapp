variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "claim-ai-test"
}

variable "environment" {
  type    = string
  default = "test"
}

variable "vpc_cidr" {
  type    = string
  default = "10.1.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "container_port" {
  type    = number
  default = 5000
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "bedrock_models" {
  type = map(string)
  default = {
    extraction_model   = "anthropic.claude-3-sonnet-20240229-v1:0"
    summarization_model = "amazon.titan-text-premier-v1:0"
  }
}
