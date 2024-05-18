provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "dev-server1" {
    count = 2
    instance_type = "t2.micro"
    ami = "ami-0bb84b8ffd87024d8"
    key_name = "privkey"
    subnet_id = "subnet-0a611ced4615fd6e8"
    /*security_groups = "sg-0ef5a3bf94b3e492e"*/

    tags = {
      Name = "devserver${count.index+1}"
    }
  
}

output "instance_ip_addr" {
  value = aws_instance.dev-server1.private_ip
}
