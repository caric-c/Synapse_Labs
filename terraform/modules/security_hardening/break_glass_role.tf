# show path: Synapse_Labs/terraform/modules/security_hardening/break_glass_role.tf


# create break glass iam_role with trust policy to allow specific mfa_user_arn to assume role
resource "aws_iam_role" "break_glass" {
  name                 = "BreakGlassAdminRole"
  max_session_duration = 3600 # 1 hour cap, setup iam role emergency access time limited 

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { "AWS" = var.mfa_user_arn },
      Action    = "sts:AssumeRole",
      Condition = { Bool = { "aws:MultiFactorAuthPresent" = "true" } } # require MFA 
    }]
  })
}



# create iam_policy to deny all actions if mfa is older than 15 minutes (900 seconds) for safer
resource "aws_iam_role_policy" "break_glass_fresh_mfa_deny" {
  name = "DenyIfMFATooOld"
  role = aws_iam_role.break_glass.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid:    "DenyActionsIfMFAOlderThan15m",
      Effect: "Deny",
      Action: "*",
      Resource: "*",
      Condition: {
        NumericGreaterThan: {
          "aws:MultiFactorAuthAge": 900 # 15 minutes
        }
      }
    }]
  })
}


# attach admin iam_policy to break glass iam_role
resource "aws_iam_role_policy_attachment" "admin_policy_attach" {
  role       = aws_iam_role.break_glass.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
