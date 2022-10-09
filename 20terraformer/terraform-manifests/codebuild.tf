
resource "aws_iam_role" "BuildProjectRole" {
  description          = "Policy used in trust relationship with CodeBuild"
  name                 = "CodeBuildBasePolicy-${random_pet.this.id}"
  path                 = "/"
  tags                 = local.common_tags
  max_session_duration = "3600"
  assume_role_policy   = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      }
    }
  ],
  "Version": "2012-10-17"
}
POLICY
  inline_policy {
    name = "${local.name}-CodeBuildPolicy"
    policy = jsonencode(
      {
        Version = "2012-10-17"
        Statement = [
          {
            Action = [
              "logs:CreateLogGroup",
              "logs:CreateLogStream",
              "logs:PutLogEvents"
            ]
            Effect   = "Allow"
            Resource = "*"
          },
          {
            Action = [
              "s3:PutObject",
              "s3:GetObject",
              "s3:GetObjectVersion",
              "s3:GetBucketAcl",
              "s3:GetBucketLocation"
            ]
            Effect   = "Allow"
            Resource = "*"
          },
          {
            Action = [
              "codebuild:CreateReportGroup",
              "codebuild:CreateReport",
              "codebuild:UpdateReport",
              "codebuild:BatchPutTestCases",
              "codebuild:BatchPutCodeCoverages"
            ]
            Effect   = "Allow"
            Resource = "*"
          },
          {
            Action = [
              "ecr:GetAuthorizationToken"
            ]
            Effect   = "Allow"
            Resource = "*"
          },
          {
            Action = [
              "ecr:DescribeImageScanFindings",
              "ecr:GetLifecyclePolicyPreview",
              "ecr:GetDownloadUrlForLayer",
              "ecr:BatchGetImage",
              "ecr:DescribeImages",
              "ecr:ListTagsForResource",
              "ecr:BatchCheckLayerAvailability",
              "ecr:GetLifecyclePolicy",
              "ecr:GetRepositoryPolicy",
              "ecr:PutImage",
              "ecr:InitiateLayerUpload",
              "ecr:UploadLayerPart",
              "ecr:CompleteLayerUpload"
            ]
            Effect   = "Allow"
            Resource = "*"
          }
        ]
      }
    )
  }
}

resource "aws_codebuild_project" "main" {
  artifacts {
    encryption_disabled    = "false"
    name                   = "pipeline-${local.name}-BuildProject"
    override_artifact_name = "false"
    packaging              = "NONE"
    type                   = "CODEPIPELINE"
  }

  badge_enabled = "false"
  build_timeout = 60

  cache {
    modes = ["LOCAL_DOCKER_LAYER_CACHE"]
    type  = "LOCAL"
  }

  description = "Build for pipeline-${local.name}"
  # encryption_key = ""

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = "true"
    type                        = "LINUX_CONTAINER"
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      type  = "PLAINTEXT"
      value = "528163014577"
    }
  }
  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      encryption_disabled = "false"
      status              = "DISABLED"
    }
  }

  name               = "pipeline-${local.name}-BuildProject"
  project_visibility = "PRIVATE"
  queued_timeout     = "480"
  service_role       = aws_iam_role.BuildProjectRole.arn

  source {
    buildspec           = "copilot/pipelines/footle-copilot/buildspec.yml"
    git_clone_depth     = "0"
    insecure_ssl        = "false"
    report_build_status = "false"
    type                = "CODEPIPELINE"
  }
  tags = local.common_tags
}
