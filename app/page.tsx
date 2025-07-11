import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { Button } from "@/components/ui/button"
import {
  Github,
  ExternalLink,
  Cloud,
  Server,
  Database,
  Activity,
  FileText,
  Zap,
  HardDrive,
  Network,
  Eye,
  Settings,
} from "lucide-react"

const services = [
  {
    name: "Amazon EC2",
    description: "t2.micro instance with Amazon Linux 2",
    icon: Server,
    color: "text-orange-600",
    bgColor: "bg-orange-50",
    borderColor: "border-orange-200",
    task: "Launch a t2.micro instance with Amazon Linux 2",
    screenshot: "ec2_instance.png",
  },
  {
    name: "Amazon VPC",
    description: "Custom VPC with public subnet and Internet Gateway",
    icon: Network,
    color: "text-blue-600",
    bgColor: "bg-blue-50",
    borderColor: "border-blue-200",
    task: "Create a custom VPC with 1 public subnet and Internet Gateway",
    screenshot: "vpc_setup.png",
  },
  {
    name: "AWS Lambda",
    description: "Hello World function in Python",
    icon: Zap,
    color: "text-yellow-600",
    bgColor: "bg-yellow-50",
    borderColor: "border-yellow-200",
    task: "Create a simple Lambda function (Hello World in Python)",
    screenshot: "lambda_function.png",
  },
  {
    name: "Amazon S3",
    description: "Private bucket with versioning enabled",
    icon: Database,
    color: "text-green-600",
    bgColor: "bg-green-50",
    borderColor: "border-green-200",
    task: "Create a private bucket with versioning enabled",
    screenshot: "s3_bucket.png",
  },
  {
    name: "Amazon EBS",
    description: "10GB EBS volume attached to EC2",
    icon: HardDrive,
    color: "text-purple-600",
    bgColor: "bg-purple-50",
    borderColor: "border-purple-200",
    task: "Attach a 10GB EBS volume to your EC2 instance",
    screenshot: "ebs_volume.png",
  },
  {
    name: "Amazon RDS",
    description: "db.t2.micro MySQL instance",
    icon: Database,
    color: "text-indigo-600",
    bgColor: "bg-indigo-50",
    borderColor: "border-indigo-200",
    task: "Launch a db.t2.micro RDS instance (MySQL)",
    screenshot: "rds_instance.png",
  },
  {
    name: "Amazon Athena",
    description: "Database and table from S3 data",
    icon: FileText,
    color: "text-teal-600",
    bgColor: "bg-teal-50",
    borderColor: "border-teal-200",
    task: "Create a database and table from sample S3 data",
    screenshot: "athena_setup.png",
  },
  {
    name: "Amazon CloudWatch",
    description: "CPU utilization alarm > 70%",
    icon: Activity,
    color: "text-red-600",
    bgColor: "bg-red-50",
    borderColor: "border-red-200",
    task: "Create an alarm for EC2 CPU utilization > 70%",
    screenshot: "cloudwatch_alarm.png",
  },
  {
    name: "AWS CloudTrail",
    description: "API activity monitoring enabled",
    icon: Eye,
    color: "text-gray-600",
    bgColor: "bg-gray-50",
    borderColor: "border-gray-200",
    task: "Enable CloudTrail to monitor API activity",
    screenshot: "cloudtrail_setup.png",
  },
  {
    name: "AWS CloudFormation",
    description: "Basic EC2 template deployment",
    icon: Settings,
    color: "text-pink-600",
    bgColor: "bg-pink-50",
    borderColor: "border-pink-200",
    task: "Deploy a basic template to create an EC2 instance",
    screenshot: "cloudformation_stack.png",
  },
  {
    name: "AWS CDK",
    description: "S3 bucket provisioned with TypeScript",
    icon: Cloud,
    color: "text-cyan-600",
    bgColor: "bg-cyan-50",
    borderColor: "border-cyan-200",
    task: "Use CDK to provision an S3 bucket (TypeScript)",
    screenshot: "cdk_deployment.png",
  },
]

export default function AWSMultiServiceShowcase() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 to-slate-100">
      {/* Header */}
      <header className="bg-white shadow-sm border-b">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
          <div className="flex items-center justify-between">
            <div>
              <h1 className="text-3xl font-bold text-gray-900">AWS Multi-Service Infrastructure</h1>
              <p className="text-gray-600 mt-1">Comprehensive Cloud Infrastructure Deployment</p>
              <div className="flex items-center gap-4 mt-2">
                <p className="text-lg font-semibold text-blue-600">Gourav</p>
                <span className="text-gray-400">|</span>
                <p className="text-sm text-gray-500">Registration No: 12203224</p>
              </div>
            </div>
            <div className="flex gap-3">
              <Button variant="outline" size="sm">
                <Github className="w-4 h-4 mr-2" />
                View Code
              </Button>
              <Button size="sm">
                <ExternalLink className="w-4 h-4 mr-2" />
                Live Demo
              </Button>
            </div>
          </div>
        </div>
      </header>

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Project Overview */}
        <section className="mb-12">
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Cloud className="w-6 h-6 text-blue-600" />
                Project Overview
              </CardTitle>
              <CardDescription>
                Comprehensive AWS infrastructure deployment covering 11 different services using Terraform and AWS CDK
              </CardDescription>
            </CardHeader>
            <CardContent>
              <div className="grid md:grid-cols-4 gap-6">
                <div className="text-center">
                  <div className="text-3xl font-bold text-blue-600">11</div>
                  <p className="text-sm text-gray-600">AWS Services</p>
                </div>
                <div className="text-center">
                  <div className="text-3xl font-bold text-green-600">100%</div>
                  <p className="text-sm text-gray-600">Free Tier</p>
                </div>
                <div className="text-center">
                  <div className="text-3xl font-bold text-purple-600">IaC</div>
                  <p className="text-sm text-gray-600">Infrastructure as Code</p>
                </div>
                <div className="text-center">
                  <div className="text-3xl font-bold text-orange-600">Secure</div>
                  <p className="text-sm text-gray-600">Best Practices</p>
                </div>
              </div>
            </CardContent>
          </Card>
        </section>

        {/* Student Information */}
        <section className="mb-12">
          <Card className="bg-gradient-to-r from-blue-50 to-indigo-50 border-blue-200">
            <CardHeader>
              <CardTitle className="flex items-center gap-2 text-blue-800">
                <div className="w-10 h-10 bg-blue-600 text-white rounded-full flex items-center justify-center font-bold">
                  G
                </div>
                Student Information
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="grid md:grid-cols-2 gap-6">
                <div>
                  <h3 className="font-semibold text-gray-900 mb-2">Name</h3>
                  <p className="text-lg text-blue-600 font-medium">Gourav</p>
                </div>
                <div>
                  <h3 className="font-semibold text-gray-900 mb-2">Registration Number</h3>
                  <p className="text-lg text-blue-600 font-medium">12203224</p>
                </div>
              </div>
            </CardContent>
          </Card>
        </section>

        {/* Services Grid */}
        <section className="mb-12">
          <h2 className="text-2xl font-bold text-gray-900 mb-6">AWS Services Implemented</h2>
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
            {services.map((service, index) => {
              const IconComponent = service.icon
              return (
                <Card key={index} className={`${service.bgColor} ${service.borderColor} border-2`}>
                  <CardHeader>
                    <CardTitle className={`flex items-center gap-2 ${service.color}`}>
                      <IconComponent className="w-6 h-6" />
                      {service.name}
                    </CardTitle>
                    <CardDescription className="text-gray-700">{service.description}</CardDescription>
                  </CardHeader>
                  <CardContent>
                    <p className="text-sm text-gray-600 mb-3">{service.task}</p>
                    <div className="bg-white rounded-lg p-4 border border-gray-200">
                      <div className="flex items-center justify-center h-32 bg-gray-50 rounded border-2 border-dashed border-gray-300">
                        <div className="text-center">
                          <div className="text-gray-400 mb-2">📸</div>
                          <p className="text-sm text-gray-500">Screenshot: {service.screenshot}</p>
                        </div>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              )
            })}
          </div>
        </section>

        {/* Terraform Code Tabs */}
        <section className="mb-12">
          <h2 className="text-2xl font-bold text-gray-900 mb-6">Infrastructure Code</h2>
          <Tabs defaultValue="main" className="space-y-6">
            <TabsList className="grid w-full grid-cols-5">
              <TabsTrigger value="main">Main Config</TabsTrigger>
              <TabsTrigger value="compute">Compute</TabsTrigger>
              <TabsTrigger value="storage">Storage</TabsTrigger>
              <TabsTrigger value="network">Network</TabsTrigger>
              <TabsTrigger value="monitoring">Monitoring</TabsTrigger>
            </TabsList>

            <TabsContent value="main" className="space-y-6">
              <Card>
                <CardHeader>
                  <CardTitle>Main Terraform Configuration</CardTitle>
                  <CardDescription>Provider configuration and main resource definitions</CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="bg-gray-900 rounded-lg p-6 overflow-x-auto">
                    <pre className="text-green-400 text-sm">
                      <code>{`# Main Terraform Configuration
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# AWS Provider Configuration
provider "aws" {
  region = var.aws_region
  # Credentials configured via AWS CLI or environment variables
}

# Data sources
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Variables
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name for resource tagging"
  type        = string
  default     = "gourav-aws-showcase"
}

variable "student_name" {
  description = "Student name"
  type        = string
  default     = "Gourav"
}

variable "registration_number" {
  description = "Student registration number"
  type        = string
  default     = "12203224"
}

# Common tags
locals {
  common_tags = {
    Project            = var.project_name
    Student           = var.student_name
    RegistrationNumber = var.registration_number
    Environment       = "learning"
    ManagedBy         = "terraform"
  }
}`}</code>
                    </pre>
                  </div>
                </CardContent>
              </Card>
            </TabsContent>

            <TabsContent value="compute" className="space-y-6">
              <Card>
                <CardHeader>
                  <CardTitle>Compute Resources (EC2, Lambda)</CardTitle>
                  <CardDescription>EC2 instances and Lambda functions</CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="bg-gray-900 rounded-lg p-6 overflow-x-auto">
                    <pre className="text-green-400 text-sm">
                      <code>{`# EC2 Instance
resource "aws_instance" "main" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Hello from Gourav's EC2 Instance</h1>" > /var/www/html/index.html
  EOF
  
  tags = merge(local.common_tags, {
    Name = "\${var.project_name}-ec2"
    Type = "WebServer"
  })
}

# EBS Volume
resource "aws_ebs_volume" "main" {
  availability_zone = aws_instance.main.availability_zone
  size              = 10
  type              = "gp3"
  
  tags = merge(local.common_tags, {
    Name = "\${var.project_name}-ebs"
  })
}

# EBS Volume Attachment
resource "aws_volume_attachment" "main" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.main.id
  instance_id = aws_instance.main.id
}

# Lambda Function
resource "aws_lambda_function" "hello_world" {
  filename         = "lambda_function.zip"
  function_name    = "\${var.project_name}-hello-world"
  role            = aws_iam_role.lambda_role.arn
  handler         = "index.handler"
  runtime         = "python3.9"
  
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  
  tags = local.common_tags
}

# Lambda ZIP file
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "lambda_function.zip"
  source {
    content = <<EOF
def handler(event, context):
    return {
        'statusCode': 200,
        'body': 'Hello World from Gourav\\'s Lambda Function!'
    }
EOF
    filename = "index.py"
  }
}

# Lambda IAM Role
resource "aws_iam_role" "lambda_role" {
  name = "\${var.project_name}-lambda-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
  
  tags = local.common_tags
}

# Lambda IAM Policy Attachment
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}`}</code>
                    </pre>
                  </div>
                </CardContent>
              </Card>
            </TabsContent>

            <TabsContent value="storage" className="space-y-6">
              <Card>
                <CardHeader>
                  <CardTitle>Storage Resources (S3, RDS)</CardTitle>
                  <CardDescription>S3 buckets and RDS database instances</CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="bg-gray-900 rounded-lg p-6 overflow-x-auto">
                    <pre className="text-green-400 text-sm">
                      <code>{`# S3 Bucket
resource "aws_s3_bucket" "main" {
  bucket = "\${var.project_name}-\${random_string.bucket_suffix.result}"
  
  tags = local.common_tags
}

# S3 Bucket Versioning
resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket Public Access Block
resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id
  
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Random string for bucket naming
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# RDS Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "\${var.project_name}-db-subnet-group"
  subnet_ids = [aws_subnet.public.id, aws_subnet.private.id]
  
  tags = merge(local.common_tags, {
    Name = "\${var.project_name}-db-subnet-group"
  })
}

# RDS Instance
resource "aws_db_instance" "main" {
  identifier     = "\${var.project_name}-mysql"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"
  
  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp2"
  storage_encrypted     = true
  
  db_name  = "gouravdb"
  username = "admin"
  password = "SecurePassword123!"
  
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"
  
  skip_final_snapshot = true
  deletion_protection = false
  
  tags = merge(local.common_tags, {
    Name = "\${var.project_name}-mysql"
  })
}

# Sample S3 Object for Athena
resource "aws_s3_object" "sample_data" {
  bucket = aws_s3_bucket.main.id
  key    = "data/sample.csv"
  content = <<EOF
id,name,age,city
1,John Doe,30,New York
2,Jane Smith,25,Los Angeles
3,Bob Johnson,35,Chicago
4,Alice Brown,28,Houston
EOF
  
  tags = local.common_tags
}`}</code>
                    </pre>
                  </div>
                </CardContent>
              </Card>
            </TabsContent>

            <TabsContent value="network" className="space-y-6">
              <Card>
                <CardHeader>
                  <CardTitle>Network Resources (VPC, Subnets, Security Groups)</CardTitle>
                  <CardDescription>VPC configuration and network security</CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="bg-gray-900 rounded-lg p-6 overflow-x-auto">
                    <pre className="text-green-400 text-sm">
                      <code>{`# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = merge(local.common_tags, {
    Name = "\${var.project_name}-vpc"
  })
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  
  tags = merge(local.common_tags, {
    Name = "\${var.project_name}-igw"
  })
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  
  tags = merge(local.common_tags, {
    Name = "\${var.project_name}-public-subnet"
    Type = "Public"
  })
}

# Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
  
  tags = merge(local.common_tags, {
    Name = "\${var.project_name}-private-subnet"
    Type = "Private"
  })
}

# Route Table for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  
  tags = merge(local.common_tags, {
    Name = "\${var.project_name}-public-rt"
  })
}

# Route Table Association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Group for EC2
resource "aws_security_group" "ec2" {
  name_prefix = "\${var.project_name}-ec2-"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = merge(local.common_tags, {
    Name = "\${var.project_name}-ec2-sg"
  })
}

# Security Group for RDS
resource "aws_security_group" "rds" {
  name_prefix = "\${var.project_name}-rds-"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
  }
  
  tags = merge(local.common_tags, {
    Name = "\${var.project_name}-rds-sg"
  })
}`}</code>
                    </pre>
                  </div>
                </CardContent>
              </Card>
            </TabsContent>

            <TabsContent value="monitoring" className="space-y-6">
              <Card>
                <CardHeader>
                  <CardTitle>Monitoring & Analytics (CloudWatch, Athena, CloudTrail)</CardTitle>
                  <CardDescription>Monitoring, logging, and analytics resources</CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="bg-gray-900 rounded-lg p-6 overflow-x-auto">
                    <pre className="text-green-400 text-sm">
                      <code>{`# CloudWatch Alarm
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "\${var.project_name}-cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "70"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  
  dimensions = {
    InstanceId = aws_instance.main.id
  }
  
  tags = local.common_tags
}

# SNS Topic for Alerts
resource "aws_sns_topic" "alerts" {
  name = "\${var.project_name}-alerts"
  
  tags = local.common_tags
}

# CloudTrail S3 Bucket
resource "aws_s3_bucket" "cloudtrail" {
  bucket        = "\${var.project_name}-cloudtrail-\${random_string.bucket_suffix.result}"
  force_destroy = true
  
  tags = local.common_tags
}

# CloudTrail S3 Bucket Policy
resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSCloudTrailAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.cloudtrail.arn
      },
      {
        Sid    = "AWSCloudTrailWrite"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "\${aws_s3_bucket.cloudtrail.arn}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

# CloudTrail
resource "aws_cloudtrail" "main" {
  name           = "\${var.project_name}-cloudtrail"
  s3_bucket_name = aws_s3_bucket.cloudtrail.bucket
  
  event_selector {
    read_write_type                 = "All"
    include_management_events       = true
    exclude_management_event_sources = []
    
    data_resource {
      type   = "AWS::S3::Object"
      values = ["\${aws_s3_bucket.main.arn}/*"]
    }
  }
  
  tags = local.common_tags
  
  depends_on = [aws_s3_bucket_policy.cloudtrail]
}

# Athena Database
resource "aws_athena_database" "main" {
  name   = "gourav_database"
  bucket = aws_s3_bucket.main.bucket
  
  encryption_configuration {
    encryption_option = "SSE_S3"
  }
}

# Athena Workgroup
resource "aws_athena_workgroup" "main" {
  name = "\${var.project_name}-workgroup"
  
  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true
    
    result_configuration {
      output_location = "s3://\${aws_s3_bucket.main.bucket}/athena-results/"
      
      encryption_configuration {
        encryption_option = "SSE_S3"
      }
    }
  }
  
  tags = local.common_tags
}`}</code>
                    </pre>
                  </div>
                </CardContent>
              </Card>
            </TabsContent>
          </Tabs>
        </section>

        {/* CloudFormation Template */}
        <section className="mb-12">
          <h2 className="text-2xl font-bold text-gray-900 mb-6">CloudFormation Template</h2>
          <Card>
            <CardHeader>
              <CardTitle>Basic EC2 CloudFormation Template</CardTitle>
              <CardDescription>YAML template for deploying EC2 instance via CloudFormation</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="bg-gray-900 rounded-lg p-6 overflow-x-auto">
                <pre className="text-green-400 text-sm">
                  <code>{`# cloudformation-template.yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: 'Basic EC2 instance for Gourav (12203224)'

Parameters:
  InstanceType:
    Type: String
    Default: t2.micro
    Description: EC2 instance type
  
  KeyName:
    Type: AWS::EC2::KeyPair::KeyName
    Description: Name of an existing EC2 KeyPair

Resources:
  EC2Instance:
    Type: AWS::EC2::Instance
    Properties:
      InstanceType: !Ref InstanceType
      ImageId: ami-0c02fb55956c7d316  # Amazon Linux 2
      KeyName: !Ref KeyName
      SecurityGroups:
        - !Ref InstanceSecurityGroup
      UserData:
        Fn::Base64: !Sub |
          #!/bin/bash
          yum update -y
          yum install -y httpd
          systemctl start httpd
          systemctl enable httpd
          echo "<h1>CloudFormation EC2 - Gourav (12203224)</h1>" > /var/www/html/index.html
      Tags:
        - Key: Name
          Value: CloudFormation-EC2-Gourav
        - Key: Student
          Value: Gourav
        - Key: RegistrationNumber
          Value: '12203224'

  InstanceSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Enable SSH and HTTP access
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 22
          ToPort: 22
          CidrIp: 0.0.0.0/0
        - IpProtocol: tcp
          FromPort: 80
          ToPort: 80
          CidrIp: 0.0.0.0/0

Outputs:
  InstanceId:
    Description: InstanceId of the newly created EC2 instance
    Value: !Ref EC2Instance
  
  PublicDNS:
    Description: Public DNSName of the newly created EC2 instance
    Value: !GetAtt EC2Instance.PublicDnsName
  
  PublicIP:
    Description: Public IP address of the newly created EC2 instance
    Value: !GetAtt EC2Instance.PublicIp`}</code>
                </pre>
              </div>
            </CardContent>
          </Card>
        </section>

        {/* AWS CDK Code */}
        <section className="mb-12">
          <h2 className="text-2xl font-bold text-gray-900 mb-6">AWS CDK Implementation</h2>
          <Card>
            <CardHeader>
              <CardTitle>CDK TypeScript Code</CardTitle>
              <CardDescription>AWS CDK code to provision S3 bucket using TypeScript</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="bg-gray-900 rounded-lg p-6 overflow-x-auto">
                <pre className="text-green-400 text-sm">
                  <code>{`// cdk-app.ts
import * as cdk from 'aws-cdk-lib';
import * as s3 from 'aws-cdk-lib/aws-s3';
import { Construct } from 'constructs';

export class GouravCdkStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // S3 Bucket with CDK
    const bucket = new s3.Bucket(this, 'GouravCdkBucket', {
      bucketName: \`gourav-cdk-bucket-\${Math.random().toString(36).substring(7)}\`,
      versioned: true,
      encryption: s3.BucketEncryption.S3_MANAGED,
      blockPublicAccess: s3.BlockPublicAccess.BLOCK_ALL,
      removalPolicy: cdk.RemovalPolicy.DESTROY,
      autoDeleteObjects: true,
    });

    // Add tags
    cdk.Tags.of(bucket).add('Student', 'Gourav');
    cdk.Tags.of(bucket).add('RegistrationNumber', '12203224');
    cdk.Tags.of(bucket).add('CreatedWith', 'AWS-CDK');
    cdk.Tags.of(bucket).add('Project', 'AWS-Multi-Service-Showcase');

    // Output the bucket name
    new cdk.CfnOutput(this, 'BucketName', {
      value: bucket.bucketName,
      description: 'Name of the S3 bucket created by CDK',
    });

    new cdk.CfnOutput(this, 'BucketArn', {
      value: bucket.bucketArn,
      description: 'ARN of the S3 bucket created by CDK',
    });
  }
}

// app.ts
import * as cdk from 'aws-cdk-lib';
import { GouravCdkStack } from './cdk-app';

const app = new cdk.App();
new GouravCdkStack(app, 'GouravCdkStack', {
  env: {
    account: process.env.CDK_DEFAULT_ACCOUNT,
    region: process.env.CDK_DEFAULT_REGION,
  },
});

// package.json
{
  "name": "gourav-cdk-project",
  "version": "1.0.0",
  "description": "AWS CDK project for Gourav (12203224)",
  "scripts": {
    "build": "tsc",
    "watch": "tsc -w",
    "cdk": "cdk",
    "deploy": "cdk deploy",
    "destroy": "cdk destroy"
  },
  "dependencies": {
    "aws-cdk-lib": "^2.100.0",
    "constructs": "^10.3.0"
  },
  "devDependencies": {
    "@types/node": "^20.5.0",
    "typescript": "^5.1.6"
  }
}`}</code>
                </pre>
              </div>
            </CardContent>
          </Card>
        </section>

        {/* Deployment Instructions */}
        <section className="mb-12">
          <h2 className="text-2xl font-bold text-gray-900 mb-6">Deployment Instructions</h2>
          <div className="grid md:grid-cols-2 gap-6">
            <Card>
              <CardHeader>
                <CardTitle>Terraform Deployment</CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-3">
                  <div className="flex items-center gap-2">
                    <div className="w-6 h-6 bg-blue-600 text-white rounded-full flex items-center justify-center text-sm font-bold">
                      1
                    </div>
                    <code className="bg-gray-100 px-2 py-1 rounded text-sm">terraform init</code>
                  </div>
                  <div className="flex items-center gap-2">
                    <div className="w-6 h-6 bg-blue-600 text-white rounded-full flex items-center justify-center text-sm font-bold">
                      2
                    </div>
                    <code className="bg-gray-100 px-2 py-1 rounded text-sm">terraform plan</code>
                  </div>
                  <div className="flex items-center gap-2">
                    <div className="w-6 h-6 bg-green-600 text-white rounded-full flex items-center justify-center text-sm font-bold">
                      3
                    </div>
                    <code className="bg-gray-100 px-2 py-1 rounded text-sm">terraform apply</code>
                  </div>
                  <div className="flex items-center gap-2">
                    <div className="w-6 h-6 bg-red-600 text-white rounded-full flex items-center justify-center text-sm font-bold">
                      4
                    </div>
                    <code className="bg-gray-100 px-2 py-1 rounded text-sm">terraform destroy</code>
                  </div>
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle>CDK Deployment</CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-3">
                  <div className="flex items-center gap-2">
                    <div className="w-6 h-6 bg-purple-600 text-white rounded-full flex items-center justify-center text-sm font-bold">
                      1
                    </div>
                    <code className="bg-gray-100 px-2 py-1 rounded text-sm">npm install</code>
                  </div>
                  <div className="flex items-center gap-2">
                    <div className="w-6 h-6 bg-purple-600 text-white rounded-full flex items-center justify-center text-sm font-bold">
                      2
                    </div>
                    <code className="bg-gray-100 px-2 py-1 rounded text-sm">cdk bootstrap</code>
                  </div>
                  <div className="flex items-center gap-2">
                    <div className="w-6 h-6 bg-green-600 text-white rounded-full flex items-center justify-center text-sm font-bold">
                      3
                    </div>
                    <code className="bg-gray-100 px-2 py-1 rounded text-sm">cdk deploy</code>
                  </div>
                  <div className="flex items-center gap-2">
                    <div className="w-6 h-6 bg-red-600 text-white rounded-full flex items-center justify-center text-sm font-bold">
                      4
                    </div>
                    <code className="bg-gray-100 px-2 py-1 rounded text-sm">cdk destroy</code>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>
        </section>

        {/* Technologies Used */}
        <section className="mb-12">
          <h2 className="text-2xl font-bold text-gray-900 mb-6">Technologies & Tools Used</h2>
          <div className="flex flex-wrap gap-2">
            {[
              "Terraform",
              "AWS CDK",
              "CloudFormation",
              "TypeScript",
              "Python",
              "YAML",
              "Amazon EC2",
              "Amazon VPC",
              "AWS Lambda",
              "Amazon S3",
              "Amazon EBS",
              "Amazon RDS",
              "Amazon Athena",
              "Amazon CloudWatch",
              "AWS CloudTrail",
            ].map((tech) => (
              <Badge key={tech} variant="secondary" className="px-3 py-1">
                {tech}
              </Badge>
            ))}
          </div>
        </section>
      </main>

      {/* Footer */}
      <footer className="bg-white border-t mt-16">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
          <div className="text-center text-gray-600">
            <p className="font-semibold text-gray-800 mb-2">Gourav - Registration No: 12203224</p>
            <p>© 2024 AWS Multi-Service Infrastructure Project. Built with Next.js and deployed on Vercel.</p>
          </div>
        </div>
      </footer>
    </div>
  )
}
