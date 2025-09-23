# Synapse Labs 
This project is a simulated real-world workflow where I role-play as a **Junior Cloud Engineer** working under a manager (AI-assisted).  
The purpose is to practice **problem-solving, ticket management, and cloud operations** beyond typical student labs.

## Project Goals
- Gain real-world experience in cloud operations and DevOps practices through ticket-based tasks.
- Practice professional communication: writing incident reports, submitting PRs, and receiving feedback.
- Build confidence handling cloud infrastructure issues independently and collaboratively.

## Tech Stack
- **Cloud Platforms:** AWS, GCP (focus on AWS for Terraform + monitoring)
- **IaC & Automation:** Terraform, GitHub Actions (CI/CD), Ansible
- **Containers & Orchestration:** Docker, Kubernetes (basic exposure)
- **Monitoring & Logging:** CloudWatch, system logs
- **Languages:** Python, Bash
- **Version Control:** Git, GitHub PR workflow

## Work Process
The project followed a **ticket-based workflow**, similar to a real cloud engineering team:

- **Infrastructure Setup:**  
  Deployed AWS S3 bucket with versioning & encryption using Terraform.  
  Solved Terraform backend circular dependency issue by refactoring state files.

- **GitHub & CI/CD:**  
  Practiced Git branching and PR submissions.  
  Built a GitHub Actions CI/CD pipeline to deploy static assets to AWS S3 + CloudFront.

- **Incident Management:**  
  Handled EC2 incidents such as out-of-memory errors, disk full, and failed user-data scripts.  
  Wrote structured incident reports with root cause analysis and resolution steps.

## Lessons Learned
- Improved Terraform module design and backend state management.  
- Strengthened Git/PR workflow understanding, including rebasing and conflict resolution.  
- Learned to document and communicate incidents clearly (manager-style reporting).  
- Reinforced fundamentals of Linux troubleshooting and cloud monitoring.  

## Next Steps
- Expand into Kubernetes deployment (GKE or EKS).  
- Add automated alerting and incident notifications (CloudWatch + Slack integration).  
- Continue refining workflow with more advanced tickets.  

## How to Use
This repository is not intended as a production-ready system.  
It serves as a **learning and simulation environment** for real-world cloud workflows.  
Others can fork it to practice Terraform, CI/CD, and incident handling scenarios.

