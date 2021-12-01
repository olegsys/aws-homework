#----------RDS Instance--------------------
resource "aws_db_instance" "mysql-db" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "8.0.23"
  instance_class         = "db.t2.micro"
  name                   = "wordpressdb"
  username               = "user"
  password               = "my_db_password"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.mysql-db-subnet-group.name
  identifier             = "mysqldb"
  vpc_security_group_ids = [aws_security_group.mysql_open.id]
}
#------------------------------------------

# -------------- EC2 -----------------
resource "aws_instance" "wp-node-a" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.wordpress_a.id
  vpc_security_group_ids = [aws_security_group.allow_ssh-a.id, aws_security_group.allow_web-a.id, aws_vpc.wordpress_a.default_security_group_id]
  tags = {
    "Name" = "WP-SERVER-A"
  }
  key_name = aws_key_pair.epam_key.key_name
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",      
      "sudo mkdir -p /var/www/html",
      "sudo sh -c \"echo '${var.efs_ip}:/    /var/www/html    nfs4    _netdev,nofail,nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport  0  0' >> /etc/fstab\"",
      "sudo mount -a"
    ]
  }
  connection {
    host        = self.public_ip
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.epam_key.private_key_pem
  }
}
resource "aws_instance" "wp-node-b" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.wordpress_b.id
  vpc_security_group_ids = [aws_security_group.allow_ssh-b.id, aws_security_group.allow_web-b.id, aws_vpc.wordpress_b.default_security_group_id]
  tags = {
    "Name" = "WP-SERVER-B"
  }
  key_name = aws_key_pair.epam_key.key_name
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo mkdir -p /var/www/html",
      "sudo sh -c \"echo '${var.efs_ip}:/    /var/www/html    nfs4    _netdev,nofail,nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport  0  0' >> /etc/fstab\"",
      "sudo mount -a"
    ]
  }
  connection {
    host        = self.public_ip
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.epam_key.private_key_pem
  }
}
# -------------- EC2 -----------------

#----------Render templates-----------------
resource "local_file" "inventory" {
    content = templatefile("${path.module}/templates/inventory.tpl",
        {
            wp-node-a = aws_instance.wp-node-a.*.public_ip
            wp-node-b = aws_instance.wp-node-b.*.public_ip
        }
    )
    filename = "./ansible/inventory"
}
resource "local_file" "dbserver" {
    content = templatefile("${path.module}/templates/dbserver.tpl",
        {
             dbserver = aws_db_instance.mysql-db.address
        }
    )
    filename = "./ansible/vars/dbserver.yml"
}
#------------------------------------------
