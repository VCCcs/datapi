
resource "aws_iam_instance_profile" "ec2_profile_alvo_test" {
  name = "ec2_profile_alvo_test"
  role = aws_iam_role.ec2_role_alvo_test.name
}


//should be restricted to only our ECR repository
resource "aws_iam_role_policy" "ec2_policy" {
  name = "adult_api_policy"
  role = aws_iam_role.ec2_role_alvo_test.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "ecr:GetAuthorizationToken",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  })
}



resource "aws_iam_role" "ec2_role_alvo_test" {
  name = "ec2_role_alvo_test"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Effect" : "Allow"
      }
    ]
  })

  tags = {
    project = "alvo-api-test"
  }
}
