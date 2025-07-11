1:"$Sreact.fragment"
2:I[1063,[],""]
3:I[1483,[],""]
4:I[2278,["461","static/chunks/461-a71d99c260054b35.js","974","static/chunks/app/page-380ca63ea6682c5d.js"],"Tabs"]
5:I[2278,["461","static/chunks/461-a71d99c260054b35.js","974","static/chunks/app/page-380ca63ea6682c5d.js"],"TabsList"]
6:I[2278,["461","static/chunks/461-a71d99c260054b35.js","974","static/chunks/app/page-380ca63ea6682c5d.js"],"TabsTrigger"]
7:I[2278,["461","static/chunks/461-a71d99c260054b35.js","974","static/chunks/app/page-380ca63ea6682c5d.js"],"TabsContent"]
f:I[5125,[],"OutletBoundary"]
12:I[5125,[],"ViewportBoundary"]
14:I[5125,[],"MetadataBoundary"]
16:I[1954,[],""]
:HL["/_next/static/css/814ecb9c99da3917.css","style"]
8:T524,# Main Terraform Configuration
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
}9:T8f2,# EC2 Instance
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
    Name = "${var.project_name}-ec2"
    Type = "WebServer"
  })
}

# EBS Volume
resource "aws_ebs_volume" "main" {
  availability_zone = aws_instance.main.availability_zone
  size              = 10
  type              = "gp3"
  
  tags = merge(local.common_tags, {
    Name = "${var.project_name}-ebs"
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
  function_name    = "${var.project_name}-hello-world"
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
        'body': 'Hello World from Gourav\'s Lambda Function!'
    }
EOF
    filename = "index.py"
  }
}

# Lambda IAM Role
resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-lambda-role"
  
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
}a:T7fe,# S3 Bucket
resource "aws_s3_bucket" "main" {
  bucket = "${var.project_name}-${random_string.bucket_suffix.result}"
  
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
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = [aws_subnet.public.id, aws_subnet.private.id]
  
  tags = merge(local.common_tags, {
    Name = "${var.project_name}-db-subnet-group"
  })
}

# RDS Instance
resource "aws_db_instance" "main" {
  identifier     = "${var.project_name}-mysql"
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
    Name = "${var.project_name}-mysql"
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
}b:T98c,# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = merge(local.common_tags, {
    Name = "${var.project_name}-vpc"
  })
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  
  tags = merge(local.common_tags, {
    Name = "${var.project_name}-igw"
  })
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  
  tags = merge(local.common_tags, {
    Name = "${var.project_name}-public-subnet"
    Type = "Public"
  })
}

# Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
  
  tags = merge(local.common_tags, {
    Name = "${var.project_name}-private-subnet"
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
    Name = "${var.project_name}-public-rt"
  })
}

# Route Table Association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Group for EC2
resource "aws_security_group" "ec2" {
  name_prefix = "${var.project_name}-ec2-"
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
    Name = "${var.project_name}-ec2-sg"
  })
}

# Security Group for RDS
resource "aws_security_group" "rds" {
  name_prefix = "${var.project_name}-rds-"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
  }
  
  tags = merge(local.common_tags, {
    Name = "${var.project_name}-rds-sg"
  })
}c:Tb4c,# CloudWatch Alarm
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "${var.project_name}-cpu-alarm"
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
  name = "${var.project_name}-alerts"
  
  tags = local.common_tags
}

# CloudTrail S3 Bucket
resource "aws_s3_bucket" "cloudtrail" {
  bucket        = "${var.project_name}-cloudtrail-${random_string.bucket_suffix.result}"
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
        Resource = "${aws_s3_bucket.cloudtrail.arn}/*"
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
  name           = "${var.project_name}-cloudtrail"
  s3_bucket_name = aws_s3_bucket.cloudtrail.bucket
  
  event_selector {
    read_write_type                 = "All"
    include_management_events       = true
    exclude_management_event_sources = []
    
    data_resource {
      type   = "AWS::S3::Object"
      values = ["${aws_s3_bucket.main.arn}/*"]
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
  name = "${var.project_name}-workgroup"
  
  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true
    
    result_configuration {
      output_location = "s3://${aws_s3_bucket.main.bucket}/athena-results/"
      
      encryption_configuration {
        encryption_option = "SSE_S3"
      }
    }
  }
  
  tags = local.common_tags
}d:T6dd,# cloudformation-template.yaml
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
    Value: !GetAtt EC2Instance.PublicIpe:T79f,// cdk-app.ts
import * as cdk from 'aws-cdk-lib';
import * as s3 from 'aws-cdk-lib/aws-s3';
import { Construct } from 'constructs';

export class GouravCdkStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // S3 Bucket with CDK
    const bucket = new s3.Bucket(this, 'GouravCdkBucket', {
      bucketName: `gourav-cdk-bucket-${Math.random().toString(36).substring(7)}`,
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
}0:{"P":null,"b":"zpk-u-a0WceMiUvvz0vL9","p":"","c":["",""],"i":false,"f":[[["",{"children":["__PAGE__",{}]},"$undefined","$undefined",true],["",["$","$1","c",{"children":[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/814ecb9c99da3917.css","precedence":"next","crossOrigin":"$undefined","nonce":"$undefined"}]],["$","html",null,{"lang":"en","children":["$","body",null,{"children":["$","$L2",null,{"parallelRouterKey":"children","error":"$undefined","errorStyles":"$undefined","errorScripts":"$undefined","template":["$","$L3",null,{}],"templateStyles":"$undefined","templateScripts":"$undefined","notFound":[[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":404}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],[]],"forbidden":"$undefined","unauthorized":"$undefined"}]}]}]]}],{"children":["__PAGE__",["$","$1","c",{"children":[["$","div",null,{"className":"min-h-screen bg-gradient-to-br from-slate-50 to-slate-100","children":[["$","header",null,{"className":"bg-white shadow-sm border-b","children":["$","div",null,{"className":"max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6","children":["$","div",null,{"className":"flex items-center justify-between","children":[["$","div",null,{"children":[["$","h1",null,{"className":"text-3xl font-bold text-gray-900","children":"AWS Multi-Service Infrastructure"}],["$","p",null,{"className":"text-gray-600 mt-1","children":"Comprehensive Cloud Infrastructure Deployment"}],["$","div",null,{"className":"flex items-center gap-4 mt-2","children":[["$","p",null,{"className":"text-lg font-semibold text-blue-600","children":"Gourav"}],["$","span",null,{"className":"text-gray-400","children":"|"}],["$","p",null,{"className":"text-sm text-gray-500","children":"Registration No: 12203224"}]]}]]}],["$","div",null,{"className":"flex gap-3","children":[["$","button",null,{"className":"inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 border border-input bg-background hover:bg-accent hover:text-accent-foreground h-9 rounded-md px-3","ref":"$undefined","children":[["$","svg",null,{"ref":"$undefined","xmlns":"http://www.w3.org/2000/svg","width":24,"height":24,"viewBox":"0 0 24 24","fill":"none","stroke":"currentColor","strokeWidth":2,"strokeLinecap":"round","strokeLinejoin":"round","className":"lucide lucide-github w-4 h-4 mr-2","children":[["$","path","tonef",{"d":"M15 22v-4a4.8 4.8 0 0 0-1-3.5c3 0 6-2 6-5.5.08-1.25-.27-2.48-1-3.5.28-1.15.28-2.35 0-3.5 0 0-1 0-3 1.5-2.64-.5-5.36-.5-8 0C6 2 5 2 5 2c-.3 1.15-.3 2.35 0 3.5A5.403 5.403 0 0 0 4 9c0 3.5 3 5.5 6 5.5-.39.49-.68 1.05-.85 1.65-.17.6-.22 1.23-.15 1.85v4"}],["$","path","9comsn",{"d":"M9 18c-4.51 2-5-2-7-2"}],"$undefined"]}],"View Code"]}],["$","button",null,{"className":"inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 bg-primary text-primary-foreground hover:bg-primary/90 h-9 rounded-md px-3","ref":"$undefined","children":[["$","svg",null,{"ref":"$undefined","xmlns":"http://www.w3.org/2000/svg","width":24,"height":24,"viewBox":"0 0 24 24","fill":"none","stroke":"currentColor","strokeWidth":2,"strokeLinecap":"round","strokeLinejoin":"round","className":"lucide lucide-external-link w-4 h-4 mr-2","children":[["$","path","1q9fwt",{"d":"M15 3h6v6"}],["$","path","gplh6r",{"d":"M10 14 21 3"}],["$","path","a6xqqp",{"d":"M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"}],"$undefined"]}],"Live Demo"]}]]}]]}]}]}],["$","main",null,{"className":"max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8","children":[["$","section",null,{"className":"mb-12","children":["$","div",null,{"ref":"$undefined","className":"rounded-lg border bg-card text-card-foreground shadow-sm","children":[["$","div",null,{"ref":"$undefined","className":"flex flex-col space-y-1.5 p-6","children":[["$","div",null,{"ref":"$undefined","className":"text-2xl font-semibold leading-none tracking-tight flex items-center gap-2","children":[["$","svg",null,{"ref":"$undefined","xmlns":"http://www.w3.org/2000/svg","width":24,"height":24,"viewBox":"0 0 24 24","fill":"none","stroke":"currentColor","strokeWidth":2,"strokeLinecap":"round","strokeLinejoin":"round","className":"lucide lucide-cloud w-6 h-6 text-blue-600","children":[["$","path","p7xjir",{"d":"M17.5 19H9a7 7 0 1 1 6.71-9h1.79a4.5 4.5 0 1 1 0 9Z"}],"$undefined"]}],"Project Overview"]}],["$","div",null,{"ref":"$undefined","className":"text-sm text-muted-foreground","children":"Comprehensive AWS infrastructure deployment covering 11 different services using Terraform and AWS CDK"}]]}],["$","div",null,{"ref":"$undefined","className":"p-6 pt-0","children":["$","div",null,{"className":"grid md:grid-cols-4 gap-6","children":[["$","div",null,{"className":"text-center","children":[["$","div",null,{"className":"text-3xl font-bold text-blue-600","children":"11"}],["$","p",null,{"className":"text-sm text-gray-600","children":"AWS Services"}]]}],["$","div",null,{"className":"text-center","children":[["$","div",null,{"className":"text-3xl font-bold text-green-600","children":"100%"}],["$","p",null,{"className":"text-sm text-gray-600","children":"Free Tier"}]]}],["$","div",null,{"className":"text-center","children":[["$","div",null,{"className":"text-3xl font-bold text-purple-600","children":"IaC"}],["$","p",null,{"className":"text-sm text-gray-600","children":"Infrastructure as Code"}]]}],["$","div",null,{"className":"text-center","children":[["$","div",null,{"className":"text-3xl font-bold text-orange-600","children":"Secure"}],["$","p",null,{"className":"text-sm text-gray-600","children":"Best Practices"}]]}]]}]}]]}]}],["$","section",null,{"className":"mb-12","children":["$","div",null,{"ref":"$undefined","className":"rounded-lg border bg-card text-card-foreground shadow-sm bg-gradient-to-r from-blue-50 to-indigo-50 border-blue-200","children":[["$","div",null,{"ref":"$undefined","className":"flex flex-col space-y-1.5 p-6","children":["$","div",null,{"ref":"$undefined","className":"text-2xl font-semibold leading-none tracking-tight flex items-center gap-2 text-blue-800","children":[["$","div",null,{"className":"w-10 h-10 bg-blue-600 text-white rounded-full flex items-center justify-center font-bold","children":"G"}],"Student Information"]}]}],["$","div",null,{"ref":"$undefined","className":"p-6 pt-0","children":["$","div",null,{"className":"grid md:grid-cols-2 gap-6","children":[["$","div",null,{"children":[["$","h3",null,{"className":"font-semibold text-gray-900 mb-2","children":"Name"}],["$","p",null,{"className":"text-lg text-blue-600 font-medium","children":"Gourav"}]]}],["$","div",null,{"children":[["$","h3",null,{"className":"font-semibold text-gray-900 mb-2","children":"Registration Number"}],["$","p",null,{"className":"text-lg text-blue-600 font-medium","children":"12203224"}]]}]]}]}]]}]}],["$","section",null,{"className":"mb-12","children":[["$","h2",null,{"className":"text-2xl font-bold text-gray-900 mb-6","children":"AWS Services Implemented"}],["$","div",null,{"className":"grid md:grid-cols-2 lg:grid-cols-3 gap-6","children":[["$","div","0",{"ref":"$undefined","className":"rounded-lg text-card-foreground shadow-sm bg-orange-50 border-orange-200 border-2","children":[["$","div",null,{"ref":"$undefined","className":"flex flex-col space-y-1.5 p-6","children":[["$","div",null,{"ref":"$undefined","className":"text-2xl font-semibold leading-none tracking-tight flex items-center gap-2 text-orange-600","children":[["$","svg",null,{"ref":"$undefined","xmlns":"http://www.w3.org/2000/svg","width":24,"height":24,"viewBox":"0 0 24 24","fill":"none","stroke":"currentColor","strokeWidth":2,"strokeLinecap":"round","strokeLinejoin":"round","className":"lucide lucide-server w-6 h-6","children":[["$","rect","ngkwjq",{"width":"20","height":"8","x":"2","y":"2","rx":"2","ry":"2"}],["$","rect","iecqi9",{"width":"20","height":"8","x":"2","y":"14","rx":"2","ry":"2"}],["$","line","16zg32",{"x1":"6","x2":"6.01","y1":"6","y2":"6"}],["$","line","nzw8ys",{"x1":"6","x2":"6.01","y1":"18","y2":"18"}],"$undefined"]}],"Amazon EC2"]}],["$","div",null,{"ref":"$undefined","className":"text-sm text-gray-700","children":"t2.micro instance with Amazon Linux 2"}]]}],["$","div",null,{"ref":"$undefined","className":"p-6 pt-0","children":[["$","p",null,{"className":"text-sm text-gray-600 mb-3","children":"Launch a t2.micro instance with Amazon Linux 2"}],["$","div",null,{"className":"bg-white rounded-lg p-4 border border-gray-200","children":["$","div",null,{"className":"flex items-center justify-center h-32 bg-gray-50 rounded border-2 border-dashed border-gray-300","children":["$","div",null,{"className":"text-center","children":[["$","div",null,{"className":"text-gray-400 mb-2","children":"📸"}],["$","p",null,{"className":"text-sm text-gray-500","children":["Screenshot: ","ec2_instance.png"]}]]}]}]}]]}]]}],["$","div","1",{"ref":"$undefined","className":"rounded-lg text-card-foreground shadow-sm bg-blue-50 border-blue-200 border-2","children":[["$","div",null,{"ref":"$undefined","className":"flex flex-col space-y-1.5 p-6","children":[["$","div",null,{"ref":"$undefined","className":"text-2xl font-semibold leading-none tracking-tight flex items-center gap-2 text-blue-600","children":[["$","svg",null,{"ref":"$undefined","xmlns":"http://www.w3.org/2000/svg","width":24,"height":24,"viewBox":"0 0 24 24","fill":"none","stroke":"currentColor","strokeWidth":2,"strokeLinecap":"round","strokeLinejoin":"round","className":"lucide lucide-network w-6 h-6","children":[["$","rect","4q2zg0",{"x":"16","y":"16","width":"6","height":"6","rx":"1"}],["$","rect","8cvhb9",{"x":"2","y":"16","width":"6","height":"6","rx":"1"}],["$","rect","1egb70",{"x":"9","y":"2","width":"6","height":"6","rx":"1"}],["$","path","1jsf9p",{"d":"M5 16v-3a1 1 0 0 1 1-1h12a1 1 0 0 1 1 1v3"}],["$","path","2874zd",{"d":"M12 12V8"}],"$undefined"]}],"Amazon VPC"]}],["$","div",null,{"ref":"$undefined","className":"text-sm text-gray-700","children":"Custom VPC with public subnet and Internet Gateway"}]]}],["$","div",null,{"ref":"$undefined","className":"p-6 pt-0","children":[["$","p",null,{"className":"text-sm text-gray-600 mb-3","children":"Create a custom VPC with 1 public subnet and Internet Gateway"}],["$","div",null,{"className":"bg-white rounded-lg p-4 border border-gray-200","children":["$","div",null,{"className":"flex items-center justify-center h-32 bg-gray-50 rounded border-2 border-dashed border-gray-300","children":["$","div",null,{"className":"text-center","children":[["$","div",null,{"className":"text-gray-400 mb-2","children":"📸"}],["$","p",null,{"className":"text-sm text-gray-500","children":["Screenshot: ","vpc_setup.png"]}]]}]}]}]]}]]}],["$","div","2",{"ref":"$undefined","className":"rounded-lg text-card-foreground shadow-sm bg-yellow-50 border-yellow-200 border-2","children":[["$","div",null,{"ref":"$undefined","className":"flex flex-col space-y-1.5 p-6","children":[["$","div",null,{"ref":"$undefined","className":"text-2xl font-semibold leading-none tracking-tight flex items-center gap-2 text-yellow-600","children":[["$","svg",null,{"ref":"$undefined","xmlns":"http://www.w3.org/2000/svg","width":24,"height":24,"viewBox":"0 0 24 24","fill":"none","stroke":"currentColor","strokeWidth":2,"strokeLinecap":"round","strokeLinejoin":"round","className":"lucide lucide-zap w-6 h-6","children":[["$","path","1xq2db",{"d":"M4 14a1 1 0 0 1-.78-1.63l9.9-10.2a.5.5 0 0 1 .86.46l-1.92 6.02A1 1 0 0 0 13 10h7a1 1 0 0 1 .78 1.63l-9.9 10.2a.5.5 0 0 1-.86-.46l1.92-6.02A1 1 0 0 0 11 14z"}],"$undefined"]}],"AWS Lambda"]}],["$","div",null,{"ref":"$undefined","className":"text-sm text-gray-700","children":"Hello World function in Python"}]]}],["$","div",null,{"ref":"$undefined","className":"p-6 pt-0","children":[["$","p",null,{"className":"text-sm text-gray-600 mb-3","children":"Create a simple Lambda function (Hello World in Python)"}],["$","div",null,{"className":"bg-white rounded-lg p-4 border border-gray-200","children":["$","div",null,{"className":"flex items-center justify-center h-32 bg-gray-50 rounded border-2 border-dashed border-gray-300","children":["$","div",null,{"className":"text-center","children":[["$","div",null,{"className":"text-gray-400 mb-2","children":"📸"}],["$","p",null,{"className":"text-sm text-gray-500","children":["Screenshot: ","lambda_function.png"]}]]}]}]}]]}]]}],["$","div","3",{"ref":"$undefined","className":"rounded-lg text-card-foreground shadow-sm bg-green-50 border-green-200 border-2","children":[["$","div",null,{"ref":"$undefined","className":"flex flex-col space-y-1.5 p-6","children":[["$","div",null,{"ref":"$undefined","className":"text-2xl font-semibold leading-none tracking-tight flex items-center gap-2 text-green-600","children":[["$","svg",null,{"ref":"$undefined","xmlns":"http://www.w3.org/2000/svg","width":24,"height":24,"viewBox":"0 0 24 24","fill":"none","stroke":"currentColor","strokeWidth":2,"strokeLinecap":"round","strokeLinejoin":"round","className":"lucide lucide-database w-6 h-6","children":[["$","ellipse","msslwz",{"cx":"12","cy":"5","rx":"9","ry":"3"}],["$","path","1wlel7",{"d":"M3 5V19A9 3 0 0 0 21 19V5"}],["$","path","mv7ke4",{"d":"M3 12A9 3 0 0 0 21 12"}],"$undefined"]}],"Amazon S3"]}],["$","div",null,{"ref":"$undefined","className":"text-sm text-gray-700","children":"Private bucket with versioning enabled"}]]}],["$","div",null,{"ref":"$undefined","className":"p-6 pt-0","children":[["$","p",null,{"className":"text-sm text-gray-600 mb-3","children":"Create a private bucket with versioning enabled"}],["$","div",null,{"className":"bg-white rounded-lg p-4 border border-gray-200","children":["$","div",null,{"className":"flex items-center justify-center h-32 bg-gray-50 rounded border-2 border-dashed border-gray-300","children":["$","div",null,{"className":"text-center","children":[["$","div",null,{"className":"text-gray-400 mb-2","children":"📸"}],["$","p",null,{"className":"text-sm text-gray-500","children":["Screenshot: ","s3_bucket.png"]}]]}]}]}]]}]]}],["$","div","4",{"ref":"$undefined","className":"rounded-lg text-card-foreground shadow-sm bg-purple-50 border-purple-200 border-2","children":[["$","div",null,{"ref":"$undefined","className":"flex flex-col space-y-1.5 p-6","children":[["$","div",null,{"ref":"$undefined","className":"text-2xl font-semibold leading-none tracking-tight flex items-center gap-2 text-purple-600","children":[["$","svg",null,{"ref":"$undefined","xmlns":"http://www.w3.org/2000/svg","width":24,"height":24,"viewBox":"0 0 24 24","fill":"none","stroke":"currentColor","strokeWidth":2,"strokeLinecap":"round","strokeLinejoin":"round","className":"lucide lucide-hard-drive w-6 h-6","children":[["$","line","1y58io",{"x1":"22","x2":"2","y1":"12","y2":"12"}],["$","path","oot6mr",{"d":"M5.45 5.11 2 12v6a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-6l-3.45-6.89A2 2 0 0 0 16.76 4H7.24a2 2 0 0 0-1.79 1.11z"}],["$","line","sgf278",{"x1":"6","x2":"6.01","y1":"16","y2":"16"}],["$","line","1l4acy",{"x1":"10","x2":"10.01","y1":"16","y2":"16"}],"$undefined"]}],"Amazon EBS"]}],["$","div",null,{"ref":"$undefined","className":"text-sm text-gray-700","children":"10GB EBS volume attached to EC2"}]]}],["$","div",null,{"ref":"$undefined","className":"p-6 pt-0","children":[["$","p",null,{"className":"text-sm text-gray-600 mb-3","children":"Attach a 10GB EBS volume to your EC2 instance"}],["$","div",null,{"className":"bg-white rounded-lg p-4 border border-gray-200","children":["$","div",null,{"className":"flex items-center justify-center h-32 bg-gray-50 rounded border-2 border-dashed border-gray-300","children":["$","div",null,{"className":"text-center","children":[["$","div",null,{"className":"text-gray-400 mb-2","children":"📸"}],["$","p",null,{"className":"text-sm text-gray-500","children":["Screenshot: ","ebs_volume.png"]}]]}]}]}]]}]]}],["$","div","5",{"ref":"$undefined","className":"rounded-lg text-card-foreground shadow-sm bg-indigo-50 border-indigo-200 border-2","children":[["$","div",null,{"ref":"$undefined","className":"flex flex-col space-y-1.5 p-6","children":[["$","div",null,{"ref":"$undefined","className":"text-2xl font-semibold leading-none tracking-tight flex items-center gap-2 text-indigo-600","children":[["$","svg",null,{"ref":"$undefined","xmlns":"http://www.w3.org/2000/svg","width":24,"height":24,"viewBox":"0 0 24 24","fill":"none","stroke":"currentColor","strokeWidth":2,"strokeLinecap":"round","strokeLinejoin":"round","className":"lucide lucide-database w-6 h-6","children":[["$","ellipse","msslwz",{"cx":"12","cy":"5","rx":"9","ry":"3"}],["$","path","1wlel7",{"d":"M3 5V19A9 3 0 0 0 21 19V5"}],["$","path","mv7ke4",{"d":"M3 12A9 3 0 0 0 21 12"}],"$undefined"]}],"Amazon RDS"]}],["$","div",null,{"ref":"$undefined","className":"text-sm text-gray-700","children":"db.t2.micro MySQL instance"}]]}],["$","div",null,{"ref":"$undefined","className":"p-6 pt-0","children":[["$","p",null,{"className":"text-sm text-gray-600 mb-3","children":"Launch a db.t2.micro RDS instance (MySQL)"}],["$","div",null,{"className":"bg-white rounded-lg p-4 border border-gray-200","children":["$","div",null,{"className":"flex items-center justify-center h-32 bg-gray-50 rounded border-2 border-dashed border-gray-300","children":["$","div",null,{"className":"text-center","children":[["$","div",null,{"className":"text-gray-400 mb-2","children":"📸"}],["$","p",null,{"className":"text-sm text-gray-500","children":["Screenshot: ","rds_instance.png"]}]]}]}]}]]}]]}],["$","div","6",{"ref":"$undefined","className":"rounded-lg text-card-foreground shadow-sm bg-teal-50 border-teal-200 border-2","children":[["$","div",null,{"ref":"$undefined","className":"flex flex-col space-y-1.5 p-6","children":[["$","div",null,{"ref":"$undefined","className":"text-2xl font-semibold leading-none tracking-tight flex items-center gap-2 text-teal-600","children":[["$","svg",null,{"ref":"$undefined","xmlns":"http://www.w3.org/2000/svg","width":24,"height":24,"viewBox":"0 0 24 24","fill":"none","stroke":"currentColor","strokeWidth":2,"strokeLinecap":"round","strokeLinejoin":"round","className":"lucide lucide-file-text w-6 h-6","children":[["$","path","1rqfz7",{"d":"M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z"}],["$","path","tnqrlb",{"d":"M14 2v4a2 2 0 0 0 2 2h4"}],["$","path","b1mrlr",{"d":"M10 9H8"}],["$","path","t4e002",{"d":"M16 13H8"}],["$","path","z1uh3a",{"d":"M16 17H8"}],"$undefined"]}],"Amazon Athena"]}],["$","div",null,{"ref":"$undefined","className":"text-sm text-gray-700","children":"Database and table from S3 data"}]]}],["$","div",null,{"ref":"$undefined","className":"p-6 pt-0","children":[["$","p",null,{"className":"text-sm text-gray-600 mb-3","children":"Create a database and table from sample S3 data"}],["$","div",null,{"className":"bg-white rounded-lg p-4 border border-gray-200","children":["$","div",null,{"className":"flex items-center justify-center h-32 bg-gray-50 rounded border-2 border-dashed border-gray-300","children":["$","div",null,{"className":"text-center","children":[["$","div",null,{"className":"text-gray-400 mb-2","children":"📸"}],["$","p",null,{"className":"text-sm text-gray-500","children":["Screenshot: ","athena_setup.png"]}]]}]}]}]]}]]}],["$","div","7",{"ref":"$undefined","className":"rounded-lg text-card-foreground shadow-sm bg-red-50 border-red-200 border-2","children":[["$","div",null,{"ref":"$undefined","className":"flex flex-col space-y-1.5 p-6","children":[["$","div",null,{"ref":"$undefined","className":"text-2xl font-semibold leading-none tracking-tight flex items-center gap-2 text-red-600","children":[["$","svg",null,{"ref":"$undefined","xmlns":"http://www.w3.org/2000/svg","width":24,"height":24,"viewBox":"0 0 24 24","fill":"none","stroke":"currentColor","strokeWidth":2,"strokeLinecap":"round","strokeLinejoin":"round","className":"lucide lucide-activity w-6 h-6","children":[["$","path","169zse",{"d":"M22 12h-2.48a2 2 0 0 0-1.93 1.46l-2.35 8.36a.25.25 0 0 1-.48 0L9.24 2.18a.25.25 0 0 0-.48 0l-2.35 8.36A2 2 0 0 1 4.49 12H2"}],"$undefined"]}],"Amazon CloudWatch"]}],["$","div",null,{"ref":"$undefined","className":"text-sm text-gray-700","children":"CPU utilization alarm > 70%"}]]}],["$","div",null,{"ref":"$undefined","className":"p-6 pt-0","children":[["$","p",null,{"className":"text-sm text-gray-600 mb-3","children":"Create an alarm for EC2 CPU utilization > 70%"}],["$","div",null,{"className":"bg-white rounded-lg p-4 border border-gray-200","children":["$","div",null,{"className":"flex items-center justify-center h-32 bg-gray-50 rounded border-2 border-dashed border-gray-300","children":["$","div",null,{"className":"text-center","children":[["$","div",null,{"className":"text-gray-400 mb-2","children":"📸"}],["$","p",null,{"className":"text-sm text-gray-500","children":["Screenshot: ","cloudwatch_alarm.png"]}]]}]}]}]]}]]}],["$","div","8",{"ref":"$undefined","className":"rounded-lg text-card-foreground shadow-sm bg-gray-50 border-gray-200 border-2","children":[["$","div",null,{"ref":"$undefined","className":"flex flex-col space-y-1.5 p-6","children":[["$","div",null,{"ref":"$undefined","className":"text-2xl font-semibold leading-none tracking-tight flex items-center gap-2 text-gray-600","children":[["$","svg",null,{"ref":"$undefined","xmlns":"http://www.w3.org/2000/svg","width":24,"height":24,"viewBox":"0 0 24 24","fill":"none","stroke":"currentColor","strokeWidth":2,"strokeLinecap":"round","strokeLinejoin":"round","className":"lucide lucide-eye w-6 h-6","children":[["$","path","1nclc0",{"d":"M2.062 12.348a1 1 0 0 1 0-.696 10.75 10.75 0 0 1 19.876 0 1 1 0 0 1 0 .696 10.75 10.75 0 0 1-19.876 0"}],["$","circle","1v7zrd",{"cx":"12","cy":"12","r":"3"}],"$undefined"]}],"AWS CloudTrail"]}],["$","div",null,{"ref":"$undefined","className":"text-sm text-gray-700","children":"API activity monitoring enabled"}]]}],["$","div",null,{"ref":"$undefined","className":"p-6 pt-0","children":[["$","p",null,{"className":"text-sm text-gray-600 mb-3","children":"Enable CloudTrail to monitor API activity"}],["$","div",null,{"className":"bg-white rounded-lg p-4 border border-gray-200","children":["$","div",null,{"className":"flex items-center justify-center h-32 bg-gray-50 rounded border-2 border-dashed border-gray-300","children":["$","div",null,{"className":"text-center","children":[["$","div",null,{"className":"text-gray-400 mb-2","children":"📸"}],["$","p",null,{"className":"text-sm text-gray-500","children":["Screenshot: ","cloudtrail_setup.png"]}]]}]}]}]]}]]}],["$","div","9",{"ref":"$undefined","className":"rounded-lg text-card-foreground shadow-sm bg-pink-50 border-pink-200 border-2","children":[["$","div",null,{"ref":"$undefined","className":"flex flex-col space-y-1.5 p-6","children":[["$","div",null,{"ref":"$undefined","className":"text-2xl font-semibold leading-none tracking-tight flex items-center gap-2 text-pink-600","children":[["$","svg",null,{"ref":"$undefined","xmlns":"http://www.w3.org/2000/svg","width":24,"height":24,"viewBox":"0 0 24 24","fill":"none","stroke":"currentColor","strokeWidth":2,"strokeLinecap":"round","strokeLinejoin":"round","className":"lucide lucide-settings w-6 h-6","children":[["$","path","1qme2f",{"d":"M12.22 2h-.44a2 2 0 0 0-2 2v.18a2 2 0 0 1-1 1.73l-.43.25a2 2 0 0 1-2 0l-.15-.08a2 2 0 0 0-2.73.73l-.22.38a2 2 0 0 0 .73 2.73l.15.1a2 2 0 0 1 1 1.72v.51a2 2 0 0 1-1 1.74l-.15.09a2 2 0 0 0-.73 2.73l.22.38a2 2 0 0 0 2.73.73l.15-.08a2 2 0 0 1 2 0l.43.25a2 2 0 0 1 1 1.73V20a2 2 0 0 0 2 2h.44a2 2 0 0 0 2-2v-.18a2 2 0 0 1 1-1.73l.43-.25a2 2 0 0 1 2 0l.15.08a2 2 0 0 0 2.73-.73l.22-.39a2 2 0 0 0-.73-2.73l-.15-.08a2 2 0 0 1-1-1.74v-.5a2 2 0 0 1 1-1.74l.15-.09a2 2 0 0 0 .73-2.73l-.22-.38a2 2 0 0 0-2.73-.73l-.15.08a2 2 0 0 1-2 0l-.43-.25a2 2 0 0 1-1-1.73V4a2 2 0 0 0-2-2z"}],["$","circle","1v7zrd",{"cx":"12","cy":"12","r":"3"}],"$undefined"]}],"AWS CloudFormation"]}],["$","div",null,{"ref":"$undefined","className":"text-sm text-gray-700","children":"Basic EC2 template deployment"}]]}],["$","div",null,{"ref":"$undefined","className":"p-6 pt-0","children":[["$","p",null,{"className":"text-sm text-gray-600 mb-3","children":"Deploy a basic template to create an EC2 instance"}],["$","div",null,{"className":"bg-white rounded-lg p-4 border border-gray-200","children":["$","div",null,{"className":"flex items-center justify-center h-32 bg-gray-50 rounded border-2 border-dashed border-gray-300","children":["$","div",null,{"className":"text-center","children":[["$","div",null,{"className":"text-gray-400 mb-2","children":"📸"}],["$","p",null,{"className":"text-sm text-gray-500","children":["Screenshot: ","cloudformation_stack.png"]}]]}]}]}]]}]]}],["$","div","10",{"ref":"$undefined","className":"rounded-lg text-card-foreground shadow-sm bg-cyan-50 border-cyan-200 border-2","children":[["$","div",null,{"ref":"$undefined","className":"flex flex-col space-y-1.5 p-6","children":[["$","div",null,{"ref":"$undefined","className":"text-2xl font-semibold leading-none tracking-tight flex items-center gap-2 text-cyan-600","children":[["$","svg",null,{"ref":"$undefined","xmlns":"http://www.w3.org/2000/svg","width":24,"height":24,"viewBox":"0 0 24 24","fill":"none","stroke":"currentColor","strokeWidth":2,"strokeLinecap":"round","strokeLinejoin":"round","className":"lucide lucide-cloud w-6 h-6","children":[["$","path","p7xjir",{"d":"M17.5 19H9a7 7 0 1 1 6.71-9h1.79a4.5 4.5 0 1 1 0 9Z"}],"$undefined"]}],"AWS CDK"]}],["$","div",null,{"ref":"$undefined","className":"text-sm text-gray-700","children":"S3 bucket provisioned with TypeScript"}]]}],["$","div",null,{"ref":"$undefined","className":"p-6 pt-0","children":[["$","p",null,{"className":"text-sm text-gray-600 mb-3","children":"Use CDK to provision an S3 bucket (TypeScript)"}],["$","div",null,{"className":"bg-white rounded-lg p-4 border border-gray-200","children":["$","div",null,{"className":"flex items-center justify-center h-32 bg-gray-50 rounded border-2 border-dashed border-gray-300","children":["$","div",null,{"className":"text-center","children":[["$","div",null,{"className":"text-gray-400 mb-2","children":"📸"}],["$","p",null,{"className":"text-sm text-gray-500","children":["Screenshot: ","cdk_deployment.png"]}]]}]}]}]]}]]}]]}]]}],["$","section",null,{"className":"mb-12","children":[["$","h2",null,{"className":"text-2xl font-bold text-gray-900 mb-6","children":"Infrastructure Code"}],["$","$L4",null,{"defaultValue":"main","className":"space-y-6","children":[["$","$L5",null,{"className":"grid w-full grid-cols-5","children":[["$","$L6",null,{"value":"main","children":"Main Config"}],["$","$L6",null,{"value":"compute","children":"Compute"}],["$","$L6",null,{"value":"storage","children":"Storage"}],["$","$L6",null,{"value":"network","children":"Network"}],["$","$L6",null,{"value":"monitoring","children":"Monitoring"}]]}],["$","$L7",null,{"value":"main","className":"space-y-6","children":["$","div",null,{"ref":"$undefined","className":"rounded-lg border bg-card text-card-foreground shadow-sm","children":[["$","div",null,{"ref":"$undefined","className":"flex flex-col space-y-1.5 p-6","children":[["$","div",null,{"ref":"$undefined","className":"text-2xl font-semibold leading-none tracking-tight","children":"Main Terraform Configuration"}],["$","div",null,{"ref":"$undefined","className":"text-sm text-muted-foreground","children":"Provider configuration and main resource definitions"}]]}],["$","div",null,{"ref":"$undefined","className":"p-6 pt-0","children":["$","div",null,{"className":"bg-gray-900 rounded-lg p-6 overflow-x-auto","children":["$","pre",null,{"className":"text-green-400 text-sm","children":["$","code",null,{"children":"$8"}]}]}]}]]}]}],["$","$L7",null,{"value":"compute","className":"space-y-6","children":["$","div",null,{"ref":"$undefined","className":"rounded-lg border bg-card text-card-foreground shadow-sm","children":[["$","div",null,{"ref":"$undefined","className":"flex flex-col space-y-1.5 p-6","children":[["$","div",null,{"ref":"$undefined","className":"text-2xl font-semibold leading-none tracking-tight","children":"Compute Resources (EC2, Lambda)"}],["$","div",null,{"ref":"$undefined","className":"text-sm text-muted-foreground","children":"EC2 instances and Lambda functions"}]]}],["$","div",null,{"ref":"$undefined","className":"p-6 pt-0","children":["$","div",null,{"className":"bg-gray-900 rounded-lg p-6 overflow-x-auto","children":["$","pre",null,{"className":"text-green-400 text-sm","children":["$","code",null,{"children":"$9"}]}]}]}]]}]}],["$","$L7",null,{"value":"storage","className":"space-y-6","children":["$","div",null,{"ref":"$undefined","className":"rounded-lg border bg-card text-card-foreground shadow-sm","children":[["$","div",null,{"ref":"$undefined","className":"flex flex-col space-y-1.5 p-6","children":[["$","div",null,{"ref":"$undefined","className":"text-2xl font-semibold leading-none tracking-tight","children":"Storage Resources (S3, RDS)"}],["$","div",null,{"ref":"$undefined","className":"text-sm text-muted-foreground","children":"S3 buckets and RDS database instances"}]]}],["$","div",null,{"ref":"$undefined","className":"p-6 pt-0","children":["$","div",null,{"className":"bg-gray-900 rounded-lg p-6 overflow-x-auto","children":["$","pre",null,{"className":"text-green-400 text-sm","children":["$","code",null,{"children":"$a"}]}]}]}]]}]}],["$","$L7",null,{"value":"network","className":"space-y-6","children":["$","div",null,{"ref":"$undefined","className":"rounded-lg border bg-card text-card-foreground shadow-sm","children":[["$","div",null,{"ref":"$undefined","className":"flex flex-col space-y-1.5 p-6","children":[["$","div",null,{"ref":"$undefined","className":"text-2xl font-semibold leading-none tracking-tight","children":"Network Resources (VPC, Subnets, Security Groups)"}],["$","div",null,{"ref":"$undefined","className":"text-sm text-muted-foreground","children":"VPC configuration and network security"}]]}],["$","div",null,{"ref":"$undefined","className":"p-6 pt-0","children":["$","div",null,{"className":"bg-gray-900 rounded-lg p-6 overflow-x-auto","children":["$","pre",null,{"className":"text-green-400 text-sm","children":["$","code",null,{"children":"$b"}]}]}]}]]}]}],["$","$L7",null,{"value":"monitoring","className":"space-y-6","children":["$","div",null,{"ref":"$undefined","className":"rounded-lg border bg-card text-card-foreground shadow-sm","children":[["$","div",null,{"ref":"$undefined","className":"flex flex-col space-y-1.5 p-6","children":[["$","div",null,{"ref":"$undefined","className":"text-2xl font-semibold leading-none tracking-tight","children":"Monitoring & Analytics (CloudWatch, Athena, CloudTrail)"}],["$","div",null,{"ref":"$undefined","className":"text-sm text-muted-foreground","children":"Monitoring, logging, and analytics resources"}]]}],["$","div",null,{"ref":"$undefined","className":"p-6 pt-0","children":["$","div",null,{"className":"bg-gray-900 rounded-lg p-6 overflow-x-auto","children":["$","pre",null,{"className":"text-green-400 text-sm","children":["$","code",null,{"children":"$c"}]}]}]}]]}]}]]}]]}],["$","section",null,{"className":"mb-12","children":[["$","h2",null,{"className":"text-2xl font-bold text-gray-900 mb-6","children":"CloudFormation Template"}],["$","div",null,{"ref":"$undefined","className":"rounded-lg border bg-card text-card-foreground shadow-sm","children":[["$","div",null,{"ref":"$undefined","className":"flex flex-col space-y-1.5 p-6","children":[["$","div",null,{"ref":"$undefined","className":"text-2xl font-semibold leading-none tracking-tight","children":"Basic EC2 CloudFormation Template"}],["$","div",null,{"ref":"$undefined","className":"text-sm text-muted-foreground","children":"YAML template for deploying EC2 instance via CloudFormation"}]]}],["$","div",null,{"ref":"$undefined","className":"p-6 pt-0","children":["$","div",null,{"className":"bg-gray-900 rounded-lg p-6 overflow-x-auto","children":["$","pre",null,{"className":"text-green-400 text-sm","children":["$","code",null,{"children":"$d"}]}]}]}]]}]]}],["$","section",null,{"className":"mb-12","children":[["$","h2",null,{"className":"text-2xl font-bold text-gray-900 mb-6","children":"AWS CDK Implementation"}],["$","div",null,{"ref":"$undefined","className":"rounded-lg border bg-card text-card-foreground shadow-sm","children":[["$","div",null,{"ref":"$undefined","className":"flex flex-col space-y-1.5 p-6","children":[["$","div",null,{"ref":"$undefined","className":"text-2xl font-semibold leading-none tracking-tight","children":"CDK TypeScript Code"}],["$","div",null,{"ref":"$undefined","className":"text-sm text-muted-foreground","children":"AWS CDK code to provision S3 bucket using TypeScript"}]]}],["$","div",null,{"ref":"$undefined","className":"p-6 pt-0","children":["$","div",null,{"className":"bg-gray-900 rounded-lg p-6 overflow-x-auto","children":["$","pre",null,{"className":"text-green-400 text-sm","children":["$","code",null,{"children":"$e"}]}]}]}]]}]]}],["$","section",null,{"className":"mb-12","children":[["$","h2",null,{"className":"text-2xl font-bold text-gray-900 mb-6","children":"Deployment Instructions"}],["$","div",null,{"className":"grid md:grid-cols-2 gap-6","children":[["$","div",null,{"ref":"$undefined","className":"rounded-lg border bg-card text-card-foreground shadow-sm","children":[["$","div",null,{"ref":"$undefined","className":"flex flex-col space-y-1.5 p-6","children":["$","div",null,{"ref":"$undefined","className":"text-2xl font-semibold leading-none tracking-tight","children":"Terraform Deployment"}]}],["$","div",null,{"ref":"$undefined","className":"p-6 pt-0","children":["$","div",null,{"className":"space-y-3","children":[["$","div",null,{"className":"flex items-center gap-2","children":[["$","div",null,{"className":"w-6 h-6 bg-blue-600 text-white rounded-full flex items-center justify-center text-sm font-bold","children":"1"}],["$","code",null,{"className":"bg-gray-100 px-2 py-1 rounded text-sm","children":"terraform init"}]]}],["$","div",null,{"className":"flex items-center gap-2","children":[["$","div",null,{"className":"w-6 h-6 bg-blue-600 text-white rounded-full flex items-center justify-center text-sm font-bold","children":"2"}],["$","code",null,{"className":"bg-gray-100 px-2 py-1 rounded text-sm","children":"terraform plan"}]]}],["$","div",null,{"className":"flex items-center gap-2","children":[["$","div",null,{"className":"w-6 h-6 bg-green-600 text-white rounded-full flex items-center justify-center text-sm font-bold","children":"3"}],["$","code",null,{"className":"bg-gray-100 px-2 py-1 rounded text-sm","children":"terraform apply"}]]}],["$","div",null,{"className":"flex items-center gap-2","children":[["$","div",null,{"className":"w-6 h-6 bg-red-600 text-white rounded-full flex items-center justify-center text-sm font-bold","children":"4"}],["$","code",null,{"className":"bg-gray-100 px-2 py-1 rounded text-sm","children":"terraform destroy"}]]}]]}]}]]}],["$","div",null,{"ref":"$undefined","className":"rounded-lg border bg-card text-card-foreground shadow-sm","children":[["$","div",null,{"ref":"$undefined","className":"flex flex-col space-y-1.5 p-6","children":["$","div",null,{"ref":"$undefined","className":"text-2xl font-semibold leading-none tracking-tight","children":"CDK Deployment"}]}],["$","div",null,{"ref":"$undefined","className":"p-6 pt-0","children":["$","div",null,{"className":"space-y-3","children":[["$","div",null,{"className":"flex items-center gap-2","children":[["$","div",null,{"className":"w-6 h-6 bg-purple-600 text-white rounded-full flex items-center justify-center text-sm font-bold","children":"1"}],["$","code",null,{"className":"bg-gray-100 px-2 py-1 rounded text-sm","children":"npm install"}]]}],["$","div",null,{"className":"flex items-center gap-2","children":[["$","div",null,{"className":"w-6 h-6 bg-purple-600 text-white rounded-full flex items-center justify-center text-sm font-bold","children":"2"}],["$","code",null,{"className":"bg-gray-100 px-2 py-1 rounded text-sm","children":"cdk bootstrap"}]]}],["$","div",null,{"className":"flex items-center gap-2","children":[["$","div",null,{"className":"w-6 h-6 bg-green-600 text-white rounded-full flex items-center justify-center text-sm font-bold","children":"3"}],["$","code",null,{"className":"bg-gray-100 px-2 py-1 rounded text-sm","children":"cdk deploy"}]]}],["$","div",null,{"className":"flex items-center gap-2","children":[["$","div",null,{"className":"w-6 h-6 bg-red-600 text-white rounded-full flex items-center justify-center text-sm font-bold","children":"4"}],["$","code",null,{"className":"bg-gray-100 px-2 py-1 rounded text-sm","children":"cdk destroy"}]]}]]}]}]]}]]}]]}],["$","section",null,{"className":"mb-12","children":[["$","h2",null,{"className":"text-2xl font-bold text-gray-900 mb-6","children":"Technologies & Tools Used"}],["$","div",null,{"className":"flex flex-wrap gap-2","children":[["$","div","Terraform",{"className":"inline-flex items-center rounded-full border text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/80 px-3 py-1","children":"Terraform"}],["$","div","AWS CDK",{"className":"inline-flex items-center rounded-full border text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/80 px-3 py-1","children":"AWS CDK"}],["$","div","CloudFormation",{"className":"inline-flex items-center rounded-full border text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/80 px-3 py-1","children":"CloudFormation"}],["$","div","TypeScript",{"className":"inline-flex items-center rounded-full border text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/80 px-3 py-1","children":"TypeScript"}],["$","div","Python",{"className":"inline-flex items-center rounded-full border text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/80 px-3 py-1","children":"Python"}],["$","div","YAML",{"className":"inline-flex items-center rounded-full border text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/80 px-3 py-1","children":"YAML"}],["$","div","Amazon EC2",{"className":"inline-flex items-center rounded-full border text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/80 px-3 py-1","children":"Amazon EC2"}],["$","div","Amazon VPC",{"className":"inline-flex items-center rounded-full border text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/80 px-3 py-1","children":"Amazon VPC"}],["$","div","AWS Lambda",{"className":"inline-flex items-center rounded-full border text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/80 px-3 py-1","children":"AWS Lambda"}],["$","div","Amazon S3",{"className":"inline-flex items-center rounded-full border text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/80 px-3 py-1","children":"Amazon S3"}],["$","div","Amazon EBS",{"className":"inline-flex items-center rounded-full border text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/80 px-3 py-1","children":"Amazon EBS"}],["$","div","Amazon RDS",{"className":"inline-flex items-center rounded-full border text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/80 px-3 py-1","children":"Amazon RDS"}],["$","div","Amazon Athena",{"className":"inline-flex items-center rounded-full border text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/80 px-3 py-1","children":"Amazon Athena"}],["$","div","Amazon CloudWatch",{"className":"inline-flex items-center rounded-full border text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/80 px-3 py-1","children":"Amazon CloudWatch"}],["$","div","AWS CloudTrail",{"className":"inline-flex items-center rounded-full border text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/80 px-3 py-1","children":"AWS CloudTrail"}]]}]]}]]}],["$","footer",null,{"className":"bg-white border-t mt-16","children":["$","div",null,{"className":"max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8","children":["$","div",null,{"className":"text-center text-gray-600","children":[["$","p",null,{"className":"font-semibold text-gray-800 mb-2","children":"Gourav - Registration No: 12203224"}],["$","p",null,{"children":"© 2024 AWS Multi-Service Infrastructure Project. Built with Next.js and deployed on Vercel."}]]}]}]}]]}],"$undefined",null,["$","$Lf",null,{"children":["$L10","$L11",null]}]]}],{},null,false]},null,false],["$","$1","h",{"children":[null,["$","$1","_Zt_k1QIB2B_j1POVWbzF",{"children":[["$","$L12",null,{"children":"$L13"}],null]}],["$","$L14",null,{"children":"$L15"}]]}],false]],"m":"$undefined","G":["$16","$undefined"],"s":false,"S":true}
13:[["$","meta","0",{"charSet":"utf-8"}],["$","meta","1",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
10:null
11:null
15:[["$","title","0",{"children":"Terraform-Task-3"}],["$","meta","1",{"name":"description","content":"Terraform-Task-3"}],["$","meta","2",{"name":"generator","content":"Terraform-Task-3"}]]
