resource "aws_instance" "wordpress" {
  ami   = "ami-08050c889a630f1bd"
  instance_type = "t2.micro"
  count = 2 
  associate_public_ip_address = "${var.mapPublicIP}"
  availability_zone = "${var.availabilityZone}"
  key_name = "${aws_key_pair.romikey-tf.key_name}"

  tags = {
        Name= "hactiv8-project-WP-${count.index}"
    }
}

