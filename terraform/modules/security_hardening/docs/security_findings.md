<!--show path: Synapse_Labs/terraform/modules/security_hardening/docs/security_findings.md-->

# Security Hub Findings – Remediation Plan

**Reviewed on:** 2025-10-09  
**Region (home):** <your-region>  
**Standards:** AWS Foundational Best Practices, CIS 1.4  
**Scope:** Findings aggregated across all regions ✅

---

## Critical / High Findings

### 1. Security groups allow 0.0.0.0/0 on ports 22 (SSH) or 3389 (RDP)
- **Severity:** High  
- **Affected resources:** sg-xxxxxxxx, sg-yyyyyyyy  
- **Root cause:** Security groups permit unrestricted inbound access on sensitive ports.  
- **Remediation:**  
  - Restrict inbound rules to **known office/VPN CIDRs** only.  
  - Example Terraform fix:
    ```hcl
    resource "aws_security_group_rule" "ssh_from_vpn" {
      type        = "ingress"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["203.0.113.0/24"] # replace with office/VPN CIDR
      security_group_id = aws_security_group.my_app_sg.id
    }
    ```
  - Remove any rule with `cidr_blocks = ["0.0.0.0/0"]` on ports 22/3389.  
- **Owner:** Network/Security Engineer  
- **ETA:** 2025-10-15  
- **Status:** Open  

---

### 2. Log retention not set on CloudWatch log groups
- **Severity:** Medium–High  
- **Affected resources:** /aws/lambda/*, /aws/api-gateway/*, (others)  
- **Root cause:** Log groups created without explicit retention → default “Never expire.”  
- **Remediation:**  
  - Enforce explicit retention across all log groups.  
  - Example Terraform fix (you already did this for CloudTrail logs with 90 days):
    ```hcl
    resource "aws_cloudwatch_log_group" "app_logs" {
      name              = "/aws/myapp/production"
      retention_in_days = 90
    }
    ```
  - Standardize retention policy (90/180/365 days depending on compliance).  
- **Owner:** Platform Engineer  
- **ETA:** 2025-10-20  
- **Status:** In progress  

---

### 3. IAM wildcard risks in policies (`*`)
- **Severity:** High  
- **Affected resources:** DeveloperLeastPrivilege policy, possibly others.  
- **Root cause:** IAM policies grant `"Action": "*"`, `"Resource": "*"`, or broad permissions.  
- **Remediation:**  
  - Replace wildcards with **specific ARNs** or **least-privilege actions**.  
  - Example fix:
    ```json
    {
      "Sid": "S3AccessForAppAssets",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::my-app-assets",
        "arn:aws:s3:::my-app-assets/*"
      ]
    }
    ```
  - Review all IAM policies in Terraform for `*` and scope them down.  
- **Owner:** IAM/Security Engineer  
- **ETA:** 2025-10-25  
- **Status:** Open  

---

## Notes
- Evidence collected from Security Hub findings.  
- Remediation will be tracked in Jira ticket `SEC-###`.  
- Next review date: **2025-11-09** (30-day follow-up).  
