# Cloud Course Project

## Project Overview
This project automates the provisioning of scalable and resilient public cloud infrastructure on AWS using Terraform. It is designed to deploy a simple Python-based RESTful API, supported by a robust backend infrastructure that includes an Application Load Balancer (ALB), Auto Scaling EC2 instances, load testing with Locust, and an RDS PostgreSQL database.

## Python code

The FastAPI Python code is available in [this repository](https://github.com/victorlga/simple_python_crud).

The Locust Python code is available in [this repository](https://github.com/victorlga/locust_python_tester/tree/main).

## Infrastructure Components

### Region

Reasons for choosing North Virginia:

1. Maturity and Service Range: As one of AWS's oldest and most mature regions, North Virginia offers a comprehensive array of services. This is crucial for our project which relies on various AWS services like EC2, RDS, and ALB.
2. Cost-Effectiveness: Due to its scale, North Virginia often offers competitive pricing, which is beneficial for managing the project budget effectively.
3. Rich Community and Ecosystem: The strong AWS user community in this region is an excellent resource for support, best practices, and even talent acquisition.
4. Data Center Density: The high density of data centers in this region ensures robust infrastructure support. This aspect is vital for the high availability and resilience required by our application.

### Networking
- **VPC**: A custom Virtual Private Cloud (VPC) is set up with a CIDR block of `10.0.0.0/16`.
- **Subnets**: Includes both public (`10.0.1.0/24`, `10.0.2.0/24`) and private (`10.0.3.0/24`, `10.0.4.0/24`) subnets spread across two availability zones for high availability.

### Application Load Balancer (ALB)
- Configured to distribute incoming traffic across EC2 instances in private subnets, ensuring efficient load handling and fault tolerance.

### EC2 Instances and Auto Scaling
- EC2 instances are deployed within the private subnets, running a Python RESTful API.
- Auto Scaling is configured to automatically adjust the number of instances based on load with AWS CloudWatch Metric Alarms, ensuring efficient resource utilization.
- Application running on EC2 instances is monitored using AWS CloudWatch logs.
- Auto-scaling group with a minimal size of 2 to facilitate load balancer testing.
- Auto-scaling group launches new EC2 instance when CPU utilization reaches 70% or ALB Request Count Per Target reaches 200. It takes around 3 minutes of activity to start up-scaling
- Auto-scaling group ends EC2 instance when ALB Request Count Per Target reaches 160. It takes around 15 minutes of inactivity to start down-scaling.
- Auto-scaling thresholds were defined to allow the demonstration of its operation.

### RDS MySQL Database
- A MySQL database instance is provisioned in the private subnets, offering secure and scalable database services.
- Configured for multi-AZ deployments for high availability and automated backups for data durability.
- Database's user and password are managed with AWS Secrets Manager.

### Security Groups
- Defined for ALB, EC2 with auto-scaling instances, EC2 for Locust instance, and RDS to ensure secure access control. 
- The ALB security group allows HTTP/HTTPS traffic, whereas the EC2 security group permits traffic from the ALB. The RDS security group allows database connections from EC2 instances. The Locust security group allows all traffic.

### Internet Gateways, NAT Gateways, and Route Tables
- Internet Gateways are set up in each public subnet to enable outbound internet access to the load balancer.
- NAT Gateways are set up in each private subnet to enable the load balancer to redirect traffic to resources in the private subnets.
- Route Tables are configured for both public and private subnets to control network routing.

## Deployment and Management
- All resources are defined and managed using Terraform, providing a reliable and repeatable process for infrastructure deployment.
- The infrastructure's configuration is modularized for better organization and easier maintenance.

## Getting Started
To deploy this infrastructure, ensure you have Terraform installed and configured with AWS credentials of an account with access to S3 bucket. Follow the steps below:

0. Make sure you have Terraform (v1.6.3) installed and configured with AWS credentials
1. Initialize Terraform: `terraform init`
2. Plan the deployment: `terraform plan`
3. Apply the configuration: `terraform apply -auto-approve`
4. Wait for AWS to finish launching instances. This may take a few minutes.
5. Copy the load balancer's DNS from terminal outputs and paste it into the browser
6. Test API endpoints
7. Copy the ec2-locust instance's DNS from terminal outputs and paste it into the browser
8. Run a load test with 100 users and a spawn rate of 100 to see autoscaling launch a new instance. This may take a few (a bit more) minutes.
9. Destroy the infrastructure: `terraform destroy -auto-approve`
