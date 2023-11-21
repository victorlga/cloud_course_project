resource "aws_instance" "ec2_locust" {
    ami                         = var.ami
    instance_type               = var.instance_type
    vpc_security_group_ids      = [var.ec2_sg_id]
    subnet_id                   = var.public_sub_1_id

    #iam_instance_profile        = var.ec2_profile_name
    user_data = base64encode(templatefile("${path.module}/user_data.tftpl", {
        lb_endpoint = var.lb_endpoint
    }))

    tags = {
        Name = "ec2-locust"
    }
}