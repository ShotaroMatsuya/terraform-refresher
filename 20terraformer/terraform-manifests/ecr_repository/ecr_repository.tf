resource "aws_ecr_repository" "firelens-fluentbit" {
  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = "true"
  }

  image_tag_mutability = "MUTABLE"
  name                 = "test/fluentbit"
  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "aws_ecr_repository" "php" {
  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = "true"
  }

  image_tag_mutability = "MUTABLE"
  name                 = "test/php"
  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "aws_ecr_repository" "nginx" {
  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = "true"
  }

  image_tag_mutability = "MUTABLE"
  name                 = "test/nginx"
  # lifecycle {
  #   prevent_destroy = true
  # }
}
