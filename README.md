# DevOPs Technical Projects, an SOP and learning guide
## Title : An Automated Deployment of a .NET & PostgreSQL
## Author: [George Osei Bonsu]
## Date : [09.09.2025]

## General Overview
This project illustrates an automated infrastructure provisioning and application deployment pipeline. I used **Terraform (Iac) to create an Ubuntu EC2 instance on AWS and ** Ansible to configure the instance and deployed a containirized .NET core application with a PostgreSQL database using ** Docker Compose**.

I aimed at creating a prototype structure that gives much information on architeural choices, security considerations and best usage of Iac (Infrastructure as code) and CM (Configuration Management)  and the use of packaging (Containerisation)

## Architeural and Design

The project is designed to be modular and scalable, allowing for easy modifications and extensions. The architecture consists of the following components:

1. **Infrastructure Provisioning**: Terraform was used to define and provision the infrastructure resources on AWS, including an EC2 instance running Ubuntu.
2. **Configuration Management**: Ansible as an agentless and simplified and idempotent power tool with the help of roles and playbook ensured consistent server configuration.
3. **Containerization**: Docker (Docker Compose) was used to containerize the .NET core application and PostgreSQL database, ensuring consistency across different environments.


4. **Security**: Security best practices were followed, using security groups to expose only important ports (SSH: 22 , HTTP: 80), and encrypted communication channels.
-**KeyNote** In a production enviroment, SSH access is keen on restriction to a bastion host or specific IP ranges. Secrets (eg.database passwords) would be managed using a vault (eg ansible vault, AWS IAM roles) and not harded in tempaltes.

### Projecture Structure 


Terraform-ansible-docker-stack/
├── terraform/ # Infrastructure provisioning code
│ ├── main.tf # Defines AWS provider, security group, and EC2 instance
│ ├── variables.tf # Declares input variables for customization
│ ├── outputs.tf # Outputs the EC2 instance's public IP for Ansible
├── ansible/
│ ├── playbook.yml # Main Ansible playbook to configure the server and deploy the app
│ ├──ansible.cfg
│ ├──docker-compose.yml
│ ├── roles/
│ │ ├── app/
│ │ │ ├── tasks/
│ │ │ │ ├── main.yml # Tasks to deploy the .NET core application
│ │ │ ├── docker/
│ │ │ │ ├── tasks/
│ │ │ │ │ ├── main.yml # Tasks to install Docker and Docker Compose
└── README.md # This file

## Prerequisites
In running this project, the following installations were run on my host machine
- Terraform (v1.0+)
- Ansible   (v2.10+)
- AWS CLI
- Docker and Docker Compose (for local testing)
- An **AWS Key Pair** for SSH access
**Key note: i also ran WSL and installed ubuntu server on my host machine to ensure ansible usage as a best practice and easy other than running it on the cloud server which is a possible practice but somewhat confusing**

## Usage Instructions

### Phase 1: Provision Infrastructure with Terraform

1.  Navigate to the Terraform directory:
    ```bash
    cd terraform
    ```
2.  Initialize Terraform and download the AWS provider:
    ```bash
    terraform init
    ```
3.  Review the execution plan:
    ```bash
    terraform plan
    ```
4.  Apply the configuration to create the EC2 instance and security group:
    ```bash
    terraform apply
    ```
    Type `yes` to confirm. Note the `instance_public_ip` output.

    ### Phase 2: Configure and Deploy with Ansible
1. Install Ubuntu server on WSL using  

2.  Update the Ansible inventory file with the IP from the previous step:
    ```bash
    # Edit ansible/inventory.ini and replace <EC2_PUBLIC_IP> with the output from:
    terraform output -raw instance_public_ip
    ```
3.  Run the Ansible playbook to install Docker and deploy the application:
    ```bash
    cd ../ansible
    ansible-playbook -i inventory.ini playbook.yml
    ```

    ### Validation

After the playbook completes successfully:
1.  Open a web browser.
2.  Navigate to `http://<YOUR_EC2_PUBLIC_IP>`.
3.  You should see the default ASP.NET sample application homepage.

### Key Notes and Guide
- **Terraform State Management**: In a production environment, consider using remote state storage (e.g., AWS S3 with DynamoDB for locking) to manage Terraform state files securely.
- **Ansible Best Practices**: Use Ansible Vault to encrypt sensitive data such as database passwords. Modularize playbooks and roles for better maintainability.
- **Docker Compose**: For more complex applications, consider using Docker Swarm or Kubernetes for orchestration and scaling.
- The Docker Compose file uses a public sample .NET image for simplicity. In a real scenario, this would be built from a custom Dockerfile.
- Cost Alert: The created EC2 instance will incur a small cost. Remember to destroy it when finished.

### Cleanup
To avoid unnecessary charges, destroy the infrastructure when no longer needed:
1.  Destroy the Terraform-managed infrastructure:
    ```bash
    cd terraform
    terraform destroy
    ```
    Type `yes` to confirm.


### Future Probes
This prototype serves as a foundation. Next steps would include:
Integrating a CI/CD pipeline (e.g., GitLab CI) to run Terraform and Ansible on commit.
Building a custom Docker image for the application.
Implementing secure secret management.
Adding monitoring (e.g., Prometheus, Grafana)