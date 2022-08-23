locals {
    service-ports = ["80", "443"]
    allow-cidr    = "0.0.0.0/0"
}


resource "aws_security_group" "custom-lb-sg" {
    name = "${var.env_prefix}-custom-lb-sg"
    description = "Ingress for lb"
    vpc_id      = aws_vpc.myapp_vpc.id

    dynamic "ingress" {
        iterator = port
        for_each = local.service-ports
        content {
            from_port       = port.value
            to_port         = port.value
            protocol        = "TCP"
            cidr_blocks     = [local.allow-cidr]
        }
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.env_prefix}-custom-lb-sg"
    }
}

# # outbound rules
# resource "aws_security_group_rule" "lb_outgoing" {
#     type                    = "egress"
#     from_port               = 0
#     to_port                 = 0
#     protocol                = "-1"
#     cidr_blocks             = ["0.0.0.0/0"]
# }