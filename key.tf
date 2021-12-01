resource "tls_private_key" "epam_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "epam_key" {
  key_name   = "epam_key"       
  public_key = tls_private_key.epam_key.public_key_openssh

  provisioner "local-exec" { 
    command = "echo '${tls_private_key.epam_key.private_key_pem}' > ./ansible/epam_key.pem && chmod 600 ./ansible/epam_key.pem"    
  }
}