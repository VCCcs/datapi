resource "null_resource" "docker_packaging" {

  provisioner "local-exec" {
    command = <<EOF
	    aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.eu-west-1.amazonaws.com
	    docker build --platform linux/amd64 -t "${aws_ecr_repository.alvo-vcc.repository_url}:latest" -f Dockerfile .
	    docker push "${aws_ecr_repository.alvo-vcc.repository_url}:latest"
	    EOF
  }


  triggers = {
    "run_at" = timestamp()
  }


  depends_on = [
    aws_ecr_repository.alvo-vcc,
  ]
}


resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.data_vpc_main.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "lb" {
  name        = "LB-SG"
  description = "Allow inbound and outbound traffic to load balancer from the internet."
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = aws_vpc.data_vpc_main.id
}


resource "aws_instance" "api" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.micro"
  count         = var.instances_count

  root_block_device {
    volume_size = 8
  }

  vpc_security_group_ids = [aws_security_group.sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile_alvo_test.name
  subnet_id              = aws_subnet.data_public_subnet.id

  user_data = base64encode(templatefile("user_data.sh", local.vars))


  tags = {
    project = var.project_name
    Name = "${var.project_name}-${count.index +1}"
  }

  key_name                = aws_key_pair.default.key_name
  monitoring              = true
  disable_api_termination = false
  ebs_optimized           = true

  lifecycle {
    ignore_changes = [user_data]
  }
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "default" {
  key_name   = "api-ssh-key"
  public_key = tls_private_key.key.public_key_openssh
}

locals {
  vars = {
    repository_url = aws_ecr_repository.alvo-vcc.repository_url
  }
}


