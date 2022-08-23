resource "aws_security_group" "custom-ec2-sg" {
    name = "${var.env_prefix}-custom-ec2-sg"
    description = "Ingress for ec2"
    vpc_id      = aws_vpc.myapp_vpc.id

    ingress {
        description      = "allow http access only from alb"
        from_port        = 3003
        to_port          = 3003
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        # security_groups = [aws_security_group.custom-lb-sg.id]
    }

    ingress {
        description      = "ssh access from anywhere"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.env_prefix}-custom-ec2-sg"
    }
}