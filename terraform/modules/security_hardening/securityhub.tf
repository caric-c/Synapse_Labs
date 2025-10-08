# show path: Synapse_Labs/terraform/modules/security_hardening/securityhub.tf


# Enable Security Hub in this region
resource "aws_securityhub_account" "main" {
  enable_default_standards = false # false = we control the standards we want, if true = all standards control by AWS
}


# Subscribe to "AWS Foundational Security Best Practices"
# "securityhub_standards_subscription" provides a set of security controls to help you improve your security posture
resource "aws_securityhub_standards_subscription" "best_practices" {
  standards_arn = "arn:aws:securityhub:${var.region}::standards/aws-foundational-security-best-practices/v/1.0.0"
  depends_on    = [aws_securityhub_account.main] # ensure Security Hub is enabled first before subscribing to "AWS Foundational Security Best Practices"
}


# Subscribe to "CIS 1.4 rules" (Optional)
# necessary for company wants to be ISO 27001 or SOC 2 compliant
resource "aws_securityhub_standards_subscription" "cis_14" {
  standards_arn = "arn:aws:securityhub:${var.region}::standards/cis-aws-foundations-benchmark/v/1.4.0"
  depends_on    = [aws_securityhub_account.main] # ensure Security Hub is enabled first before subscribing to "CIS 1.4 rules"
}


# (Optional) Aggregate findings from all regions into this one so you don't miss hidden issues
# This is useful for organizations that have resources in multiple regions and want a centralized view of security
resource "aws_securityhub_finding_aggregator" "all_regions" {
  linking_mode = "ALL_REGIONS"
}
