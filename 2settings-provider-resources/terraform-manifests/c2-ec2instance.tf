# Resource: EC2 Instance
resource "aws_instance" "myec2vm" {
  ami           = "ami-0f36dcfcc94112ea1"
  instance_type = "t3.micro"
  user_data     = file("${path.module}/app1-install.sh")
  tags = {
    "name" = "EC2 Demo"
  }
}