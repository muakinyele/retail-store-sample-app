Deployment & Architecture Guide

Overview — InnovateMart Retail Store Application

High-Level Summary
The InnovateMart Retail Store Application is deployed on Amazon EKS (Elastic Kubernetes Service) using a fully automated GitHub Actions CI/CD pipeline.The infrastructure (networking, cluster, IAM roles, and node groups) is provisioned via Terraform, while application deployment and updates are managed through GitHub Actions.
This architecture ensures a declarative, repeatable, and secure deployment workflow aligned with modern DevOps practices.

Architecture Components
Infrastructure Layer — Terraform (IaC)
Terraform provisions the foundational AWS resources:
VPC
Multi-AZ setup with public and private subnets
NAT Gateways and Internet Gateway for controlled ingress/egress traffic
EKS Cluster
Control plane managed by AWS
Worker nodes (Node Groups) running on EC2 within private subnets
IAM Roles and Policies
eks-admin user with cluster access
github-actions-eks-deploy OIDC role for GitHub Actions to deploy securely without static credentials
Security Groups
Allow inbound HTTPS (443) and application ports (e.g., 80/8080)
ECR Repository
Stores custom Docker images if needed (retail-store-sample-app)
All resources are defined in Terraform modules for modularity and reuse.After applying Terraform, EKS is ready for workloads.
The terraform file is located inside the terraform folder.

Application Layer — GitHub Actions (CI/CD)
The GitHub Actions workflow (.github/workflows/deploy.yml and .github/workflows/terrafrom-deploy.yml) automates:
Checkout Source Code
Deploys and automates server setups from terraform to AWS
Assume the OIDC IAM Role (github-actions-eks-deploy)
Update kubeconfig to connect to EKS
Deploy In-Cluster Dependencies:
PostgreSQL (stateful backend database)
DynamoDB Local (NoSQL component for session/state simulation)
Redis
RabbitMQ (message broker)
MySQL
Deploy Application (Retail Store Sample App)
Uses public container image:public.ecr.aws/aws-containers/retail-store-sample-ui:1.3.0
Kubernetes manifests (Deployment + Service) applied directly from:
https://github.com/aws-containers/retail-store-sample-app/releases/latest/download/kubernetes.yaml
Wait for rollout and expose via AWS Load Balancer Service
Output External URL for public access
Post Deployment Summary and optional PR comment
Runtime Layer — Kubernetes Workloads
Inside the EKS cluster:
Component
Description
Type
retail-store-sample-ui
Frontend web UI (React + Node.js) served via Kubernetes Deployment
Deployment
PostgreSQL
Relational database for persistent data
StatefulSet
DynamoDB Local
Simulates AWS DynamoDB in-cluster for dev/test
Deployment
Redis/RabbitMQ
Message broker for internal microservices
Deployment
Kubernetes Service (LoadBalancer)
Exposes the frontend app publicly
Service
AWS Load Balancer (via EKS Service Controller) provides the external-ip hostname accessible from the internet.

CI/CD Flow Diagram


Security Highlights
IAM OIDC Integration — GitHub Actions authenticates via OpenID Connect (no static AWS keys).
Private Networking — Databases and message brokers run in private subnets.
Role-Based Access Control (RBAC) — eks-admin mapped to system:masters for full access.
Terraform State Backend — Can be stored securely in S3 with DynamoDB locking.

Accessing the Application
Once deployment completes, the GitHub Actions job prints the LoadBalancer EXTERNAL-IP or hostname:
kubectl get svc ui -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
Access the app in your browser at:
http://acc9867073cd6493bb576e4287dfb9e1-200832378.us-east-1.elb.amazonaws.com/

EKS Read-Only Developer Access Guide
User: innovatemart-dev-readonlyCluster: innovatemart-eksRegion: us-east-1Provisioned via: Terraform (This ensures the user can view EKS cluster details, networking, logs, and container repositories — but cannot modify any AWS resources.)

The innovatemart-dev-readonly IAM user provides secure, read-only access to the InnovateMart Amazon EKS cluster. 
This allows developers or auditors to:
View resources, logs, and configurations.
Troubleshoot or inspect workloads.
Access Kubernetes objects without permission to modify or delete.
This access is managed through IAM policies (for AWS-level permissions), and RBAC bindings (for 
Kubernetes-level access).

Branch for Terraform Pipeline CI/CD is master
Branch for Application Pipeline CI/CD is main