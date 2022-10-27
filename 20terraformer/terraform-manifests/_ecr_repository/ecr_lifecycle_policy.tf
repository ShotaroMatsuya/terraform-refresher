resource "aws_ecr_lifecycle_policy" "firelens-fluentbit" {
  policy     = <<POLICY
{
  "rules": [
    {
      "action": {
        "type": "expire"
      },
      "description": "古いイメージの削除",
      "rulePriority": 1,
      "selection": {
        "countNumber": 15,
        "countType": "imageCountMoreThan",
        "tagStatus": "any"
      }
    }
  ]
}
POLICY
  repository = aws_ecr_repository.firelens-fluentbit.name
}

resource "aws_ecr_lifecycle_policy" "php" {
  policy = <<POLICY
{
  "rules": [
    {
      "action": {
        "type": "expire"
      },
      "description": "古いイメージの削除",
      "rulePriority": 1,
      "selection": {
        "countNumber": 30,
        "countType": "imageCountMoreThan",
        "tagStatus": "any"
      }
    }
  ]
}
POLICY

  repository = aws_ecr_repository.php.name
}

resource "aws_ecr_lifecycle_policy" "nginx" {
  policy = <<POLICY
{
  "rules": [
    {
      "action": {
        "type": "expire"
      },
      "description": "古いイメージの削除",
      "rulePriority": 1,
      "selection": {
        "countNumber": 30,
        "countType": "imageCountMoreThan",
        "tagStatus": "any"
      }
    }
  ]
}
POLICY

  repository = aws_ecr_repository.nginx.name
}
