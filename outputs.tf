# output "subnet_ids" {
#   #value = [for s in data.aws_subnet.stack_subnets : s.cidr_block]
#   value = [for s in data.aws_subnet.stack_sub : s.id]
#   #value = [for s in data.aws_subnet.stack_sub : s.availability_zone]
#   #value = [for s in data.aws_subnet.stack_sub : element(split("-", s.availability_zone), 2)]
# }

# output "load_balancer_dns_clixx" {
#   description = "The DNS address of the load balancer."
#   value       = aws_lb.clixx_lb.dns_name
#   depends_on  = [aws_lb.clixx_lb]
# }

# output "load_balancer_dns_blog" {
#   description = "The DNS address of the load balancer."
#   value       = aws_lb.blog_lb.dns_name
#   depends_on  = [aws_lb.blog_lb]
# }

# output "efs_id_clixx" {
#   description = "EFS ID of file system"
#   value       = aws_efs_file_system.efs_1.id
#   depends_on  = [aws_efs_file_system.efs_1]
# }

# output "efs_id_blog" {
#   description = "EFS ID of file system"
#   value       = aws_efs_file_system.efs_blog.id
#   depends_on  = [aws_efs_file_system.efs_blog]
# }

