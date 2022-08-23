resource "aws_key_pair" "ssh-key" {
    key_name   = "${var.env_prefix}-server-key"
    public_key = file(var.ssh_public_key)
}

# aws ec2 describe-images --region us-east-1 --image-ids ami-0cff7528ff583bf9a
data "aws_ami" "amazon-linux-custom-image" {
    most_recent      = true
    owners           = ["self"] 
    filter {
        name   = "name"
        values = [var.custom_ami_name]
    }
}

# its a template, which contains all instance settings to apply to each newly launched instance by autoscaling group
resource "aws_launch_template" "ec2" {
    name_prefix                 = "${var.env_prefix}-ec2"
    vpc_security_group_ids      = [aws_security_group.custom-ec2-sg.id]
    image_id                    = data.aws_ami.amazon-linux-custom-image.id
    instance_type               = var.instance_type
    key_name                    = aws_key_pair.ssh-key.key_name

    monitoring {
        enabled = false
    }

    tag_specifications {
        resource_type           = "instance"

        tags = {
            Name                = "${var.env_prefix}-ec2-launch-template"
            Service             = "${var.env_prefix}-ec2-launch-template"
        }
    }
}