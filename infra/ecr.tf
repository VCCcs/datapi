resource "aws_ecr_repository" "alvo-vcc" {
  name = var.project_name

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    project = var.project_name
  }
  force_delete = true
}

resource "aws_ecr_lifecycle_policy" "default_policy" {
  repository = aws_ecr_repository.alvo-vcc.name


  policy = jsonencode({
    "rules" : [
      {
        "rulePriority" : 1,
        "description" : "Keep only the last 1 untagged images.",
        "selection" : {
          "tagStatus" : "untagged",
          "countType" : "imageCountMoreThan",
          "countNumber" : 1
        },
        "action" : {
          "type" : "expire"
        }
      }
    ]
  })
}