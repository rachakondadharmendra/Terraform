resource "aws_iam_role" "cicd_build_role" {
  name = "cicd-container-app-build-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "cicd_build_policy_document" {
  statement {
    actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    actions   = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
      "ec2:CreateNetworkInterfacePermission",
      "s3:*",
      "ecr:*",
      "ecs:*",
      "ssm:DescribeParameters",
      "ssm:GetParameters",
      "kms:Decrypt",
    ]
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "cicd_build_policy" {
  name        = "cicd-container-app-build-policy"
  description = "IAM Policy for CI/CD Container App Build"
  path        = "/"  
  policy      = data.aws_iam_policy_document.cicd_build_policy_document.json
}

resource "aws_iam_role_policy_attachment" "cicd_build_role_attachment" {
  policy_arn = aws_iam_policy.cicd_build_policy.arn
  role       = aws_iam_role.cicd_build_role.name
}


resource "aws_iam_role" "cicd_codepipeline_role" {
  name = "cicd-code-pipeline-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "cicd_codepipeline_policy_document" {
  statement {
    actions   = ["iam:PassRole"]
    resources = ["*"]
    effect    = "Allow"

    condition {
      test = "StringEqualsIfExists"
      variable = "iam:PassedToService"
      values = [
        "cloudformation.amazonaws.com",
        "elasticbeanstalk.amazonaws.com",
        "ec2.amazonaws.com",
        "ecs-tasks.amazonaws.com",
      ]
    }
  }

  statement {
    actions   = [
      "codecommit:CancelUploadArchive",
      "codecommit:GetBranch",
      "codecommit:GetCommit",
      "codecommit:GetRepository",
      "codecommit:GetUploadArchiveStatus",
      "codecommit:UploadArchive",
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    actions   = [
      "codedeploy:CreateDeployment",
      "codedeploy:GetApplication",
      "codedeploy:GetApplicationRevision",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentConfig",
      "codedeploy:RegisterApplicationRevision",
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    actions   = ["codestar-connections:UseConnection"]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    actions   = [
      "elasticbeanstalk:*",
      "ec2:*",
      "elasticloadbalancing:*",
      "autoscaling:*",
      "cloudwatch:*",
      "s3:*",
      "sns:*",
      "cloudformation:*",
      "rds:*",
      "sqs:*",
      "ecs:*",
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    actions   = ["lambda:InvokeFunction", "lambda:ListFunctions"]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    actions   = [
      "opsworks:CreateDeployment",
      "opsworks:DescribeApps",
      "opsworks:DescribeCommands",
      "opsworks:DescribeDeployments",
      "opsworks:DescribeInstances",
      "opsworks:DescribeStacks",
      "opsworks:UpdateApp",
      "opsworks:UpdateStack",
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    actions   = [
      "cloudformation:CreateStack",
      "cloudformation:DeleteStack",
      "cloudformation:DescribeStacks",
      "cloudformation:UpdateStack",
      "cloudformation:CreateChangeSet",
      "cloudformation:DeleteChangeSet",
      "cloudformation:DescribeChangeSet",
      "cloudformation:ExecuteChangeSet",
      "cloudformation:SetStackPolicy",
      "cloudformation:ValidateTemplate",
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    actions   = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
      "codebuild:BatchGetBuildBatches",
      "codebuild:StartBuildBatch",
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    actions   = [
      "devicefarm:ListProjects",
      "devicefarm:ListDevicePools",
      "devicefarm:GetRun",
      "devicefarm:GetUpload",
      "devicefarm:CreateUpload",
      "devicefarm:ScheduleRun",
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    actions   = [
      "servicecatalog:ListProvisioningArtifacts",
      "servicecatalog:CreateProvisioningArtifact",
      "servicecatalog:DescribeProvisioningArtifact",
      "servicecatalog:DeleteProvisioningArtifact",
      "servicecatalog:UpdateProduct",
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    actions   = ["cloudformation:ValidateTemplate"]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    actions   = ["ecr:*"]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    actions   = ["states:DescribeExecution", "states:DescribeStateMachine", "states:StartExecution"]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    actions   = ["appconfig:StartDeployment", "appconfig:StopDeployment", "appconfig:GetDeployment"]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    actions   = ["ssm:DescribeParameters"]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    actions   = ["ssm:GetParameters"]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    actions   = ["kms:Decrypt"]
    resources = ["*"]
    effect    = "Allow"
  }

  version = "2012-10-17"
}


resource "aws_iam_policy" "cicd_codepipeline_policy" {
  name        = "cicd-code-pipeline-policy"
  path        = "/"
  description = "IAM Policy for CI/CD Apps CodePipeline"
  policy      = data.aws_iam_policy_document.cicd_codepipeline_policy_document.json
}


resource "aws_iam_role_policy_attachment" "cicd_codepipeline_role_attachment" {
  policy_arn = aws_iam_policy.cicd_codepipeline_policy.arn
  role       = aws_iam_role.cicd_codepipeline_role.name
}


