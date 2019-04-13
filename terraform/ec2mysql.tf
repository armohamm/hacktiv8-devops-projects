resource "aws_instance" "mysql" {
  ami   = "ami-08050c889a630f1bd" 
  instance_type = "t2.micro"
  count = 1
  tenancy = "${var.instanceTenancy}"
  associate_public_ip_address = "${var.mapPublicIP}"
  availability_zone = "${var.availabilityZone}"
  key_name = "${aws_key_pair.romikey-tf.key_name}"

  

 # provisioner "file" {
 #   source = "ec2mysql.sh"
 #   destination = "~/ec2mysql.sh"
 # }
 # provisioner "remote-exec" {
 #   inline = [
 #     "chmod + x ~/ec2mysql.sh",
 #     "sudo ~/ec2mysql.sh"
 #   ]
 # }
  
 # connection {
 #   user = "${var.instanceUsername}"
  
  tags = {
    Name= "hactiv8-project-MYSQL"
    }
}