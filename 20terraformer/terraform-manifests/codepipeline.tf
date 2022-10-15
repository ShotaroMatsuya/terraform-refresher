resource "aws_iam_role" "PipelineRole" {
  max_session_duration = "3600"
  name                 = "${local.name}-PipelineRole-${random_pet.this.id}"
  path                 = "/"
  tags                 = local.common_tags
  assume_role_policy   = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      }
    }
  ],
  "Version": "2012-10-17"
}
POLICY
  inline_policy {
    name = "${local.name}-CodepipelinePolicy"
    policy = jsonencode(
      {
        Version = "2012-10-17"
        Statement = [
          {
            Action = [
              "codepipeline:*",
              "codecommit:GetBranch",
              "codecommit:GetCommit",
              "codecommit:UploadArchive",
              "codecommit:GetUploadArchiveStatus",
              "codecommit:CancelUploadArchive",
              "iam:ListRoles",
              "codebuild:BatchGetBuilds",
              "codebuild:StartBuild",
              "iam:PassRole",
              "s3:ListAllMyBuckets",
              "s3:GetBucketLocation"
            ]
            Resource = "*"
            Effect   = "Allow"
          },
          {
            Action = [
              "codestar-connections:CreateConnection",
              "codestar-connections:DeleteConnection",
              "codestar-connections:GetConnection",
              "codestar-connections:ListConnections",
              "codestar-connections:GetIndividualAccessToken",
              "codestar-connections:GetInstallationUrl",
              "codestar-connections:ListInstallationTargets",
              "codestar-connections:StartOAuthHandshake",
              "codestar-connections:UpdateConnectionInstallation",
              "codestar-connections:UseConnection",
              "codestar-connections:RegisterAppCode",
              "codestar-connections:StartAppRegistrationHandshake",
              "codestar-connections:StartUploadArchiveToS3",
              "codestar-connections:GetUploadArchiveToS3Status",
              "codestar-connections:PassConnection",
              "codestar-connections:PassedToService"
            ]
            Resource = "*"
            Effect   = "Allow"
          },
          {
            Action = [
              "kms:Decrypt",
              "kms:Encrypt",
              "kms:GenerateDataKey"
            ]
            Resource = "*"
            Effect   = "Allow"
          },
          {
            Action = [
              "s3:PutObject",
              "s3:GetBucketPolicy",
              "s3:GetObject",
              "s3:ListBucket",
              "s3:PutObjectAcl",
              "s3:GetObjectAcl"
            ]
            Resource = "*"
            Effect   = "Allow"
          }
        ]
      }
    )
  }
}

resource "aws_s3_bucket" "artifact" {
  bucket        = "${local.name}-codepipeline-artifacts"
  force_destroy = true

  # grant {
  #   id          = "442b44e2c49db7482d68ac975348bf2b481acec1d983d874583f4e5fb95dd1d1"
  #   permissions = ["FULL_CONTROL"]
  #   type        = "CanonicalUser"
  # }

  # hosted_zone_id      = "Z2M4EHUR26P7ZW"
  # object_lock_enabled = "false"

  lifecycle_rule {
    enabled = true

    expiration {
      days = "180"
    }
  }
  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
}

resource "aws_codestarconnections_connection" "main" {
  name          = "example-connection"
  provider_type = "GitHub"
}
/*
data "aws_kms_alias" "s3kmskey" {
  name = "alias/myKmsKey"
}
*/

resource "aws_codepipeline" "main" {
  artifact_store {
    # encryption_key {
    #   id   = "arn:aws:kms:ap-northeast-1:266309316896:key/2f6a9b21-48f9-4aa2-ab62-f5be6417fce3"
    #   type = "KMS"
    # }

    location = aws_s3_bucket.artifact.id
    type     = "S3"
  }

  name     = "pipeline-${local.name}"
  role_arn = aws_iam_role.PipelineRole.arn
  stage {
    action {
      category = "Source"

      configuration = {
        BranchName           = "master"
        ConnectionArn        = aws_codestarconnections_connection.main.arn
        DetectChanges        = "true"
        FullRepositoryId     = "ShotaroMatsuya/footle"
        OutputArtifactFormat = "CODE_ZIP"
      }

      name             = "SourceCodeFor-${local.name}"
      output_artifacts = ["SCCheckoutArtifact"]
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      region           = var.aws_region
      run_order        = "1"
      version          = "1"
    }

    name = "Source"
  }
  stage {
    action {
      category = "Build"

      configuration = {
        ProjectName = "pipeline-${local.name}-BuildProject"
      }

      input_artifacts  = ["SCCheckoutArtifact"]
      name             = "Build"
      output_artifacts = ["BuildOutput"]
      owner            = "AWS"
      provider         = "CodeBuild"
      run_order        = "1"
      version          = "1"
    }

    name = "Build"
  }
  stage {
    action {
      category = "Deploy"

      configuration = {
        ClusterName = aws_ecs_cluster.main.name
        FileName    = "imagedefinitions.json"
        ServiceName = aws_ecs_service.main.name
      }

      input_artifacts = ["BuildOutput"]
      name            = "Deploy"
      namespace       = "DeployVariables"
      owner           = "AWS"
      provider        = "ECS"
      region          = var.aws_region
      run_order       = "1"
      version         = "1"
    }

    name = "Deploy"
  }
  /*
  stage {
    action {
      category = "Approval"

      configuration = {
        CustomData         = "リンクから承認すると現在のstgがprodに反映されます"
        ExternalEntityLink = "https://www.google.com"
        NotificationArn    = aws_sns_topic.main.arn
      }

      name      = "ApprovePromotionTo-prod"
      owner     = "AWS"
      provider  = "Manual"
      region    = var.aws_region
      run_order = "1"
      version   = "1"
    }

    action {
      category = "Deploy"

      configuration = {
        ClusterName = aws_ecs_cluster.main.name
        FileName    = "imagedefinitions.json"
        ServiceName = aws_ecs_service.main.name
      }

      input_artifacts = ["BuildOutput"]
      name            = "Deploy"
      namespace       = "DeployVariables"
      owner           = "AWS"
      provider        = "ECS"
      region          = var.aws_region
      run_order       = "1"
      version         = "1"
    }

    name = "DeployTo-prod"
  }
*/

  tags = local.common_tags

}

## Notification: CodePipeline app
resource "aws_codestarnotifications_notification_rule" "pipeline" {
  detail_type = "BASIC"
  event_type_ids = [
    "codepipeline-pipeline-stage-execution-started",
    "codepipeline-pipeline-stage-execution-succeeded",
    "codepipeline-pipeline-stage-execution-resumed",
    "codepipeline-pipeline-stage-execution-canceled",
    "codepipeline-pipeline-stage-execution-failed",
    "codepipeline-pipeline-pipeline-execution-failed",
    "codepipeline-pipeline-pipeline-execution-canceled",
    "codepipeline-pipeline-pipeline-execution-started",
    "codepipeline-pipeline-pipeline-execution-resumed",
    "codepipeline-pipeline-pipeline-execution-succeeded",
    "codepipeline-pipeline-pipeline-execution-superseded",
    "codepipeline-pipeline-manual-approval-failed",
    "codepipeline-pipeline-manual-approval-needed",
    "codepipeline-pipeline-manual-approval-succeeded",
  ]

  name     = "codepipeline-notify-for-dev-app"
  resource = aws_codepipeline.main.arn

  target {
    address = aws_sns_topic.main.arn
  }
}
