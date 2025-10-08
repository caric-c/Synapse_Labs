<!--show path: Synapse_Labs/terraform/modules/security_hardening/docs/break-glass-procedure.md-->

# Break-Glass Procedure document

## 1. Purpose
The Break-Glass procedure provides **time-limited, MFA-protected emergency access** to AWS with Administrator permissions.  
It is intended for use **only when standard access methods are unavailable** (e.g., all administrators are locked out, or during critical production outages).  
All uses of this procedure must be **approved, logged, and audited**.

---

## 2. Preconditions
- **Role Name:** `BreakGlassAdminRole`  
- **Account:** `<AWS_ACCOUNT_ID>`  
- **Trust Policy:** Requires MFA (`aws:MultiFactorAuthPresent = true`)  
- **Max Session Duration:** 1 hour (3600 seconds)  
- **Monitoring:** CloudTrail enabled; EventBridge alert on AssumeRole events  
- **Approval:** Prior approval from Security Team or Incident Manager  

---

## 3. Emergency Scenarios
This procedure may be invoked if:
- Root account access is lost or compromised
- All IAM administrators are locked out
- Immediate access is required to resolve a production outage
- Security team authorizes temporary escalation for critical incident response

---

## 4. Procedure

### Step 1: Request Approval
- Contact the **Security Lead** and **Incident Manager**.
- Open an incident ticket (e.g., Jira/ServiceNow) with justification for break-glass use.

### Step 2: Authenticate with MFA
- Ensure your IAM user is enrolled with MFA.  
- Confirm your ARN is listed in the trust policy (`var.mfa_user_arn`).  

### Step 3: Assume the Break-Glass Role
Run the following command (replace `<ACCOUNT_ID>`):

```bash
aws sts assume-role \
--role-arn arn:aws:iam::<ACCOUNT_ID>:role/BreakGlassAdminRole \
--role-session-name BreakGlass-$(whoami) \
--duration-seconds 3600
```

This returns temporary credentials (AccessKeyId, SecretAccessKey, SessionToken).

### Step 4: Export Temporary Credentials
bash
Copy code
export AWS_ACCESS_KEY_ID=<AccessKeyId>
export AWS_SECRET_ACCESS_KEY=<SecretAccessKey>
export AWS_SESSION_TOKEN=<SessionToken>
Verify access:

bash
Copy code
aws sts get-caller-identity

### Step 5: Perform Emergency Tasks
Restrict actions to only those necessary to resolve the incident.
Document all commands and changes in the incident ticket.

### Step 6: Revoke Access After Use

Unset temporary credentials:
bash
Copy code
unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
Optionally, revoke STS sessions via IAM Console if required.

---

## 5. Post-Incident Actions
Notify Security Team that break-glass access is terminated.
Attach command history, console actions, or AWS CLI logs to the incident ticket.
Security Team reviews CloudTrail logs (AssumeRole for BreakGlassAdminRole) for validation.
If misuse is detected, rotate credentials and investigate.

---

## 6. Audit & Monitoring
CloudTrail logs all AssumeRole events.
EventBridge triggers alerts (SNS/Slack/email) on role usage.
Security Review: Access logs reviewed monthly.
Any unauthorized use is escalated as a security incident.

---

## 7. Contacts
In the event of break-glass activation, immediately contact:
Security Lead: <Name> (<email>, <phone>)
Incident Manager: <Name> (<email>, <phone>)
On-call Engineer: See [On-call PagerDuty/Rotation Page]
If contacts are unavailable, escalate via the Emergency Response Hotline: <phone number>

---
