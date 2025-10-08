# show path: Synapse_Labs/terraform/modules/security_hardening/iam_policies.tf

# this iam policy is base on a scenario which a app developer works on an application with: 
# Amazon S3 — stores the static website/app assets (HTML, JS, CSS, etc.)
# Amazon RDS PostgreSQL — hosts the app’s database
# developer do not manage AWS infrastructure (like IAM, networking, or creating databases) — they just deploy code, debug, and troubleshoot.


#----------------------------------------------------------------------------------

# create a IAM group for developers
resource "aws_iam_group" "developers" {
  name = "Developers"
}

# create a least privilege policy for developers
resource "aws_iam_policy" "developer_least_priv" {
  name   = "DeveloperLeastPrivilege"
  policy = jsonencode({
   
    "Version": "2012-10-17",
    "Statement": [

        # permission to upload new app to build s3 (Read+Write)
        {
        "Sid": "S3AccessForAppAssets",
        "Effect": "Allow",
        "Action": [
            "s3:ListBucket",
            "s3:GetObject",
            "s3:PutObject" 
        ],
        "Resource": [
            "arn:aws:s3:::your-app-bucket-name",
            "arn:aws:s3:::your-app-bucket-name/*"
        ]
        },

        # permission to read cloudwatch logs and metrics (ReadOnly)
        {
        "Sid": "CloudWatchAndLogsReadAccess",
        "Effect": "Allow", 
        "Action": [
            "logs:DescribeLogGroups",
            "logs:DescribeLogStreams",
            "logs:GetLogEvents",
            "cloudwatch:GetMetricData",
            "cloudwatch:ListMetrics"
        ],
        "Resource": "*"
        },

        # permission to view rds informations (ReadOnly)
        {
        "Sid": "ViewAppRDSInfo",
        "Effect": "Allow",
        "Action": [
            "rds:DescribeDBInstances",
            "rds:DescribeDBClusters"
        ],
        "Resource": "*"
        },

        # permission to re-deploy/trigger codebuild, codepipeline and codedeploy (Read+Write)
        {
        "Sid": "TriggerBuildsDeployments",
        "Effect": "Allow",
        "Action": [
            "codepipeline:StartPipelineExecution",
            "codedeploy:CreateDeployment",
            "codedeploy:Get*",
            "codedeploy:List*"
        ],
        "Resource": "*"
        },

        # permission to read ec2 infra context (ReadOnly)
        {
        "Sid": "ReadOnlyForInfraContext",
        "Effect": "Allow",
        "Action": [
            "ec2:DescribeRegions",
            "ec2:DescribeAvailabilityZones"
        ],
        "Resource": "*"
        }
    ]
  })
}

# attach the policy to the group
resource "aws_iam_group_policy_attachment" "developers_attach_least_priv" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.developer_least_priv.arn
}


#----------------------------------------------------------------------------------


# Allow CloudTrail role to write to the CloudWatch Logs group
# the cloudtrail role and attach is defined in cloudtrail.tf

resource "aws_iam_role_policy" "cloudtrail_logs_policy" {
  name = "CloudTrailWriteToCloudWatchLogs"
  role = aws_iam_role.cloudtrail_role.id  # defined in cloudtrail.tf

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect: "Allow",
        Action: [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        # IMPORTANT: scope to the specific log group, include :* for streams
        Resource: "${aws_cloudwatch_log_group.trail_logs.arn}:*"
      }
    ]
  })
}
