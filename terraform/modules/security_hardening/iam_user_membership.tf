# show path: Synapse_Labs/terraform/modules/security_hardening/iam_user_membership.tf

# Assign users to the IAM Developers group
resource "aws_iam_user_group_membership" "developer_group_membership" {
  for_each = toset(var.developer_usernames)

  user = each.value
  groups = [
    aws_iam_group.developers.name
  ]
}
