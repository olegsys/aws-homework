#----------------EFS------------------
resource "aws_efs_file_system" "efs-wp" {
  creation_token = "wordpress-efs"
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
}
resource "aws_efs_backup_policy" "policy" {
  file_system_id = aws_efs_file_system.efs-wp.id

  backup_policy {
    status = "DISABLED"
  }
}
resource "aws_efs_mount_target" "wordpress-a" {
  file_system_id  = aws_efs_file_system.efs-wp.id
  subnet_id       = aws_subnet.wordpress_a.id
  ip_address      = var.efs_ip
  security_groups = [aws_security_group.sg-efs.id]
}
#----------------EFS------------------
