# AWS Multi-Service Infrastructure Showcase

**Student:** Gourav  
**Registration Number:** 12203224

## 🎯 Project Overview

This project demonstrates comprehensive AWS infrastructure deployment across 11 different services using Infrastructure as Code (IaC) principles. The implementation showcases proficiency in Terraform, AWS CDK, and CloudFormation.

## 🏗️ AWS Services Implemented

| Service | Task | Status |
|---------|------|--------|
| **Amazon EC2** | Launch t2.micro instance with Amazon Linux 2 | ✅ |
| **Amazon VPC** | Create custom VPC with public subnet and IGW | ✅ |
| **AWS Lambda** | Create Hello World function in Python | ✅ |
| **Amazon S3** | Create private bucket with versioning | ✅ |
| **Amazon EBS** | Attach 10GB EBS volume to EC2 | ✅ |
| **Amazon RDS** | Launch db.t3.micro MySQL instance | ✅ |
| **Amazon Athena** | Create database and table from S3 data | ✅ |
| **Amazon CloudWatch** | Create CPU utilization alarm > 70% | ✅ |
| **AWS CloudTrail** | Enable API activity monitoring | ✅ |
| **AWS CloudFormation** | Deploy basic EC2 template | ✅ |
| **AWS CDK** | Provision S3 bucket with TypeScript | ✅ |

## 🔧 Tools & Technologies

- **Infrastructure as Code:** Terraform, AWS CDK, CloudFormation
- **Programming Languages:** TypeScript, Python, YAML
- **Cloud Platform:** Amazon Web Services (AWS)
- **Deployment:** Vercel (for showcase website)

## 🚀 Quick Start

### Prerequisites
\`\`\`bash
# Install required tools
brew install terraform
npm install -g aws-cdk
pip install awscli
\`\`\`

### AWS Credentials Setup
\`\`\`bash
# Configure AWS CLI
aws configure

# Or use environment variables
export AWS_ACCESS_KEY_ID=your_access_key
export AWS_SECRET_ACCESS_KEY=your_secret_key
export AWS_DEFAULT_REGION=us-east-1
\`\`\`

### Terraform Deployment
\`\`\`bash
# Initialize and deploy
terraform init
terraform plan
terraform apply

# Clean up
terraform destroy
\`\`\`

### CDK Deployment
\`\`\`bash
# Setup and deploy
npm install
cdk bootstrap
cdk deploy

# Clean up
cdk destroy
\`\`\`

### CloudFormation Deployment
\`\`\`bash
# Deploy via AWS CLI
aws cloudformation create-stack \
  --stack-name gourav-cf-stack \
  --template-body file://cloudformation-template.yaml \
  --parameters ParameterKey=KeyName,ParameterValue=your-key-name
\`\`\`

## 📸 Screenshots

Screenshots for each service are located in the `/screenshots` directory:

- `ec2_instance.png` - EC2 instance dashboard
- `vpc_setup.png` - VPC configuration
- `lambda_function.png` - Lambda function details
- `s3_bucket.png` - S3 bucket with versioning
- `ebs_volume.png` - EBS volume attachment
- `rds_instance.png` - RDS MySQL instance
- `athena_setup.png` - Athena database and table
- `cloudwatch_alarm.png` - CloudWatch CPU alarm
- `cloudtrail_setup.png` - CloudTrail configuration
- `cloudformation_stack.png` - CloudFormation stack
- `cdk_deployment.png` - CDK deployment output

## 🏛️ Architecture

\`\`\`
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Public Subnet │    │  Private Subnet │    │   Monitoring    │
│                 │    │                 │    │                 │
│  ┌───────────┐  │    │  ┌───────────┐  │    │  ┌───────────┐  │
│  │    EC2    │  │    │  │    RDS    │  │    │  │CloudWatch │  │
│  │ + EBS Vol │  │    │  │  MySQL    │  │    │  │  Alarms   │  │
│  └───────────┘  │    │  └───────────┘  │    │  └───────────┘  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │   Storage &     │
                    │   Analytics     │
                    │                 │
                    │  ┌───────────┐  │
                    │  │    S3     │  │
                    │  │  Buckets  │  │
                    │  └───────────┘  │
                    │  ┌───────────┐  │
                    │  │  Athena   │  │
                    │  │ Database  │  │
                    │  └───────────┘  │
                    └─────────────────┘
\`\`\`

## 🔒 Security Features

- **No hardcoded credentials** in source code
- **IAM roles and policies** with least privilege
- **VPC security groups** with minimal required access
- **Private subnets** for database resources
- **Encryption at rest** for S3 and RDS
- **CloudTrail logging** for audit compliance

## 📊 Cost Optimization

- All resources use **AWS Free Tier** eligible configurations
- **t2.micro/t3.micro** instances for compute
- **gp3 storage** for cost-effective EBS volumes
- **Lifecycle policies** for S3 objects
- **Auto-scaling disabled** to prevent unexpected charges

## 🎓 Learning Outcomes

This project demonstrates:

1. **Infrastructure as Code** best practices
2. **Multi-service AWS architecture** design
3. **Security and compliance** implementation
4. **Cost optimization** strategies
5. **Automation and deployment** workflows
6. **Documentation and presentation** skills

## 📝 Submission

- **Website URL:** [Deployed on Vercel]
- **GitHub Repository:** [Source code repository]
- **Screenshots:** All 11 services documented with screenshots
- **Documentation:** Comprehensive README and code comments

---

**⚠️ Important:** This project is designed for educational purposes using AWS Free Tier resources. Always monitor your AWS usage and costs.

**🎯 Academic Project:** Created by Gourav (Registration: 12203224) for cloud infrastructure learning and assessment.
