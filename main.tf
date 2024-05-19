provider "aws" {
    region = "us-east-1"
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  filter {
    name = "owner-alias"
    values = ["amazon"]
  }
}


resource "aws_instance" "dev-server1" {
    instance_type = "t2.micro"
    /*ami = data.aws_ami.amazon-linux-2.id */
    ami = var.ami
    key_name = aws_key_pair.ec2user_key.key_name
    subnet_id = aws_subnet.pubsubnet01.id
    vpc_security_group_ids = [aws_security_group.sg01.id]

    tags = {
      Name = "devserver1"
    }
    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = file("/home/joe/devuser_key/ec2_key")
      host = self.public_ip
    }
    provisioner "remote-exec" {
      inline = [
        "sudo yum update -y",
        "sudo yum install -y httpd",
        "sudo systemctl start httpd",
        "sudo systemctl enable httpd "
      ]
      
    }
  
}

resource "aws_key_pair" "ec2user_key" {
  key_name = "ec2-user"
  public_key = file("/home/joe/devuser_key/ec2_key.pub")
  
}




output "instance_ip_addr" {
  value = aws_instance.dev-server1.public_ip
}
