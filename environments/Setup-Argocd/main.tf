resource "aws_iam_role" "arctiq_role" {
  name               = "arctiq-terraform"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "example_attachment" {
  role       = aws_iam_role.arctiq_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_instance_profile" "example_profile" {
  name = "Arctiq-terraform"
  role = aws_iam_role.arctiq_role.name
}

resource "aws_security_group" "arctiq-sg" {
  name        = "Github-Action-Security-Group"
  description = "Open 22,443,80,8080,9000,3000"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  dynamic "ingress" {
    for_each = toset([22, 80, 443, 8080, 9000, 3000])
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "arctiq-sg"
  }
}

# resource "aws_security_group" "arctiq-sg" {
#   name        = "Github-Action-Security Group"
#   description = "Open 22,443,80,8080,9000"
#   vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

#   # Define a single ingress rule to allow traffic on all specified ports
#   ingress = [
#     for port in [22, 80, 443, 8080, 9000, 3000] : {
#       description      = "TLS from VPC"
#       from_port        = port
#       to_port          = port
#       protocol         = "tcp"
#       cidr_blocks      = ["0.0.0.0/0"]
#       ipv6_cidr_blocks = []
#       prefix_list_ids  = []
#       security_groups  = []
#       self             = false
#     }
#   ]

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "arctiq-sg"
#   }
# }

resource "aws_instance" "arctiq_instance" {
  ami                    = "ami-0a716d3f3b16d290c"
  instance_type          = "t3.medium"
  key_name               = "norway"
  vpc_security_group_ids = [aws_security_group.arctiq-sg.id]
  user_data              = templatefile("./script.sh", {})
  iam_instance_profile   = aws_iam_instance_profile.example_profile.name
  subnet_id              = data.terraform_remote_state.vpc.outputs.public_subnet_ids[0]


  tags = {
    Name = "github_runner"
  }
  associate_public_ip_address = true

  root_block_device {
    volume_size = 30
  }
}
