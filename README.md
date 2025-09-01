
# Infra setup for Tetris Game Application
This repository contains infrastructure components including S3, VPC, EKS, Load Balancer Controller (LBC), Cluster-Autoscaler, IRSA configuration, ArgoCD setup, and a self-hosted GitHub Actions runner for application deployments.

# Infrastructure Provisioning & Deployment with GitHub Actions
This repository automates the end-to-end setup of our cloud infrastructure and deployment pipeline using GitHub Actions, AWS, and ArgoCD.
The workflow provisions and configures all required components to enable seamless CI/CD for our applications infrastructure.

# Key Components:
1. GitHub and AWS Integration via OIDC

Secure authentication between GitHub Actions and AWS using OpenID Connect (OIDC).

Eliminates the need for long-lived AWS credentials in GitHub secrets.

Fine-grained IAM roles control which workflows can assume specific AWS permissions.

2. Self-Hosted GitHub Runner

A dedicated self-hosted runner is provisioned to handle deployments.

This runner executes workflows in a controlled environment, ideal for deploying resource-intensive applications.

Provides better performance and flexibility compared to shared GitHub-hosted runners.

3. Production-Grade Amazon EKS Cluster

Fully managed Elastic Kubernetes Service (EKS) cluster provisioned with production best practices:

AWS Load Balancer Controller (LBC) for seamless ingress/egress traffic handling.

IAM Roles for Service Accounts (IRSA) for secure pod-level AWS permissions.

Cluster Autoscaler for dynamic scaling of worker nodes based on demand.

Ensures reliability, scalability, and security for running containerized workloads.

4. Automated ArgoCD Configuration

ArgoCD is installed and configured automatically as part of the infrastructure provisioning.

Provides GitOps-driven deployment, keeping Kubernetes clusters in sync with GitHub repositories.

![Image](https://github.com/user-attachments/assets/b2e960f4-5b3a-4297-991a-61c6e244f287)

# Tetris Game Deployment as Part 2
Once the infrastructure is up, the workflow deploys a containerized Tetris game application to the EKS cluster.
This demonstrates the end-to-end CI/CD pipeline:
- Code is pushed to GitHub.
- GitHub Actions (via self-hosted runner) builds and deploys.
- ArgoCD ensures the app is continuously synchronized to EKS.
  
# Conclusion.
This setup provides a modern, production-grade cloud environment where infrastructure and applications are managed declaratively and deployed automatically.
![Image](https://github.com/user-attachments/assets/9dd2abed-39f7-4b3e-bfc2-4ea883245ccf)



Enables automated, auditable, and declarative application delivery

