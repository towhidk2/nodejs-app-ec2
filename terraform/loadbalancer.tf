locals {
    public-subnet-1 = aws_subnet.public[element(keys(aws_subnet.public),0)].id
    public-subnet-2 = aws_subnet.public[element(keys(aws_subnet.public),1)].id
    public-subnet-3 = aws_subnet.public[element(keys(aws_subnet.public),2)].id
}


# aws_lb_target_group is essentially the end point of the alb architecture - when the listener rule matches a pattern for a request it gets forwarded to the correlating target group
resource "aws_lb_target_group" "myapp_tg" {
    name                        = "${var.env_prefix}-myapp-tg"
    protocol                    = "HTTP"
    port                        = 3003
    protocol_version            = "HTTP1"
    target_type                 = "instance"
    vpc_id                      = aws_vpc.myapp_vpc.id

    health_check {
        protocol                = "HTTP"
        path                    = "/"
        port                    = "traffic-port"
        healthy_threshold       = 2 # number of checks before the instance is declared healthy
        unhealthy_threshold     = 2
        timeout                 = 5
        interval                = 10
    }

    tags = {
        Name = "${var.env_prefix}-myapp_tg"
    }
}

# aws_lb is the top level component in the architecture
resource "aws_lb" "myapp_alb" {
    name                        = "${var.env_prefix}-myapp-alb"
    internal                    = false
    ip_address_type             = "ipv4"
    load_balancer_type          = "application"
    security_groups             = [aws_security_group.custom-lb-sg.id]
    subnets                     = [local.public-subnet-1, local.public-subnet-2, local.public-subnet-3]
    tags = {
        Name = "${var.env_prefix}-myapp-alb"
    }
}

# aws_lb_listener is assigned a specific port to keep an ear out for incoming traffic
# traffic over http listener redirect to https
resource "aws_lb_listener" "http" {
    load_balancer_arn           = aws_lb.myapp_alb.arn
    port                        = "80"
    protocol                    = "HTTP"

    default_action {
        # type                    = "forward"
        # target_group_arn        = aws_lb_target_group.myapp_tg.arn
        
        type = "redirect"
        redirect {
            port        = "443"
            protocol    = "HTTPS"
            status_code = "HTTP_301"
        }
    }
}


# traffic over https listener forwards to target group
resource "aws_lb_listener" "https" {
    load_balancer_arn       = aws_lb.myapp_alb.arn
    port                    = "443"
    protocol                = "HTTPS"
    ssl_policy              = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
    certificate_arn         = aws_acm_certificate.this.arn
    
    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.myapp_tg.arn
    }

    depends_on = [ aws_acm_certificate_validation.this ]
}





# # aws_lb is the top level component in the architecture
# resource "aws_elb" "myapp_elb" {
#     name                        = "${var.env_prefix}-myapp-elb"
#     security_groups             = [aws_security_group.custom-lb-sg.id]
#     subnets                     = [local.public-subnet-1, local.public-subnet-2, local.public-subnet-3]
#     cross_zone_load_balancing   = true

#     health_check {
#         healthy_threshold       = 2
#         unhealthy_threshold     = 2
#         timeout                 = 5
#         interval                = 10
#         target                  = "HTTP:3003/"
#     }
    
#     listener {
#         lb_port                 = 80
#         lb_protocol             = "http"
#         instance_port           = "3003"
#         instance_protocol       = "http"
#     }
# }


