# Auto-Healing Web Tier on AWS

This Terraform project provisions an application load balancer in front of an Auto Scaling Group (ASG) that runs a minimal NGINX web server across at least two EC2 instances.

## Architecture

- VPC with public subnets across two AZs
- Internet-facing Application Load Balancer
- Target group with HTTP health checks on `/`
- Auto Scaling Group with `min_size = 2`, `desired_capacity = 2`, and `max_size = 3`
- Launch template that boots Amazon Linux 2 and installs NGINX

This provides the required behavior:

- Lose one VM: the ASG replaces the failed instance automatically.
- N+1 capacity: the load balancer spreads traffic across multiple healthy instances.
- IaC-only setup: a single `terraform apply` creates everything; a second run is idempotent.

## Prerequisites

- Terraform v1.15 or later
- AWS credentials configured via `aws configure`, the AWS CLI profile, or environment variables, you can also use the AWS Toolkit VSCode extension (optional, but highly recommended) 

NOTE on credentials:
- In this step, if you run into this isue: "An error occurred (InvalidClientTokenId) when calling the GetCallerIdentity operation: 
The security token included in the request is invalid.",
Please follow instructions on section "The Chosen Solution: Creating a New IAM User" of this link https://medium.com/@Ibraheemcisse/troubleshooting-aws-cli-invalidclienttokenid-error-a-real-world-solution-bfe67a36558e 

## Deploy

```bash
cd auto-healing-web-tier-vms
./deploy.sh
```

This runs:

```bash
terraform init -upgrade
terraform apply -auto-approve
```

## Verify idempotence

Run the following again after the stack is deployed:

```bash
terraform plan
```

The second run should show no changes required unless you intentionally modify the infrastructure.

## Destroy

```bash
terraform destroy
```

## Estimated costs (from C3X)
aws_vpc.main  (some line items use static rates)
    Free resource
      0 n/a × $0 = $0/mo static
    aws_vpc.main subtotal: $0/mo

  aws_internet_gateway.main  (some line items use static rates)
    Free resource
      0 n/a × $0 = $0/mo static
    aws_internet_gateway.main subtotal: $0/mo

  aws_subnet.public[0]  (some line items use static rates)
    Free resource
      0 n/a × $0 = $0/mo static
    aws_subnet.public[0] subtotal: $0/mo

  aws_subnet.public[1]  (some line items use static rates)
    Free resource
      0 n/a × $0 = $0/mo static
    aws_subnet.public[1] subtotal: $0/mo

  aws_route_table.public  (some line items use static rates)
    Free resource
      0 n/a × $0 = $0/mo static
    aws_route_table.public subtotal: $0/mo

  aws_security_group.alb  (some line items use static rates)
    Free resource
      0 n/a × $0 = $0/mo static
    aws_security_group.alb subtotal: $0/mo

  aws_security_group.web  (some line items use static rates)
    Free resource
      0 n/a × $0 = $0/mo static
    aws_security_group.web subtotal: $0/mo

  aws_lb.main
    Load balancer
      730 hours × $0.0225 = $16.425/mo
    Load balancer capacity units
      0 LCU-hours × $0.008 = $0/mo
    aws_lb.main subtotal: $16.43/mo

  aws_lb_target_group.main  (some line items use static rates)
    Target group (no charge — billed via parent load balancer)
      0 n/a × $0 = $0/mo static
    aws_lb_target_group.main subtotal: $0/mo

  aws_lb_listener.http  (some line items use static rates)
    Free resource
      0 n/a × $0 = $0/mo static
    aws_lb_listener.http subtotal: $0/mo

  aws_launch_template.web  (some line items use static rates)
    Free resource
      0 n/a × $0 = $0/mo static
    aws_launch_template.web subtotal: $0/mo

  aws_autoscaling_group.web  (some line items use static rates)
    Free resource
      0 n/a × $0 = $0/mo static
    aws_autoscaling_group.web subtotal: $0/mo

  ────────────────────────────────────────────────────────────
  PROJECT TOTAL: $16.43/mo

## Why did I choose AWS ASG(over Azure VMSS)?
The primary advantages of using AWS Auto Scaling Groups (ASG) over Azure Virtual Machine Scale Sets (VMSS) center on deeper cross-service flexibility, more granular policy controls, and a highly customizable compute ecosystem. While Azure VMSS excels in uniform, Windows-heavy virtual machine environments, AWS ASG provides superior structural agility for complex cloud architectures
Source: https://medium.com/@QuarkAndCode/azure-vs-aws-for-autoscaling-workloads-policies-pricing-fit-b87cc301cd5e

## Notes

- The default region is `ap-southeast-4`, but you can override it (for example) with `terraform apply -var='aws_region=ap-southeast-2'`.
- The ALB DNS name is exported (see outputs.tf file, line 1) for easy access in a browser.
- Reference to Terraform AWS resources: https://registry.terraform.io/providers/hashicorp/aws/latest/docs 
- Please change the aws_lb_target_group health check params (i.e. timeout) if required