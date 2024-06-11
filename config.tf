data "template_file" "bootstrap" {
  template = file(format("%s/scripts/bootstrap.tpl", path.module))
  vars = {
    GIT_REPO = local.db_creds.git_repo1 #var.git_repo1

    LB_DNS = aws_lb.clixx_lb.dns_name

    #updating rds instance / database with the new load balancer dns from terraform output
    rds_mysql_ept = local.db_creds.rds_ept #var.rds_ept
    rds_mysql_usr = local.db_creds.rds_usr #var.rds_usr
    rds_mysql_pwd = local.db_creds.rds_pwd #var.rds_pwd
    rds_mysql_db  = local.db_creds.rds_db  #var.rds_db

    #efs file system ID to be passed into bootstrap bash script for efs mount
    efs_id = aws_efs_file_system.efs_clixx.id
  }
}

data "template_file" "bootstrap_blog" {
  template = file(format("%s/scripts/bootstrap_blog.tpl", path.module))
  vars = {
    GIT_REPO_BLOG = local.db_creds.git_repo_blog #var.git_repo_blog

    LB_DNS_BLOG = aws_lb.blog_lb.dns_name

    #updating rds instance / database with the new load balancer dns from terraform output
    rds_mysql_ept_blog = local.db_creds.rds_ept_blog #var.rds_ept_blog
    rds_mysql_usr_blog = local.db_creds.rds_usr_blog #var.rds_usr_blog
    rds_mysql_pwd_blog = local.db_creds.rds_pwd_blog #var.rds_pwd_blog
    rds_mysql_db_blog  = local.db_creds.rds_db_blog  #var.rds_db_blog

    #efs file system ID to be passed into bootstrap bash script for efs mount
    efs_id_blog = aws_efs_file_system.efs_blog.id
  }
}

data "template_file" "bastion_s3_cp_bootstrap" {
  template = file(format("%s/scripts/bastion_s3_key_copy.tpl", path.module))
  vars = {
    s3_bucket = local.db_creds.s3_bucket
    pem_key   = "private-key-kp.pem"
  }
}