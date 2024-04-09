# # -------------------------------------------
# # Loab Balancer
# # -------------------------------------------

# variable "lb_name" {
#   description = "LB name"
#   type        = string
#   default     = "mylb"
# }

# variable "lb_internal" {
#   description = "Internal true or false"
#   type        = bool
#   default     = false
# }

# variable "lb_load_balancer_type" {
#   description = "Application or Network type LB"
#   type        = string
#   default     = "application"
# }

# variable "lb_enable_deletion_protection" {
#   description = "enable_deletion_protection true or false"
#   type        = bool
#   default     = false
# }

# variable "lb_target_port" {
#   description = "lb_target_port 80 or 443"
#   type        = number
#   default     = 80
# }

# variable "lb_protocol" {
#   description = "lb_protocol HTTP (ALB) or TCP (NLB)"
#   type        = string
#   default     = "HTTP"
# }

# variable "lb_target_type" {
#   description = "Target type ip (ALB/NLB), instance (Autoscaling group)"
#   type        = string
#   default     = "instance"
# }

# variable "lb_listener_port" {
#   description = "lb_listener_port"
#   type        = number
#   default     = 80
# }

# variable "lb_listener_protocol" {
#   description = "lb_listener_protocol HTTP, TCP, TLS"
#   type        = string
#   default     = "HTTP"
# }

# variable "lb_target_tags_map" {
#   description = "Tag map for the LB target resources"
#   type        = map(string)
#   default     = {}
# }

# variable "lb_target_group_arn" {
#   default = []
# }

# # -------------------------------------------
# # Launch Template
# # -------------------------------------------

# variable "image_id" {
#   description = "AMI image ID for the launch template instances"
#   type        = string
#   default     = "ami-02d7fd1c2af6eead0"
# }

# variable "instance_type" {
#   description = "instance type for the launch template instances"
#   type        = string
#   default     = "t2.micro"
# }

# variable "key_name" {
#   default = "my_key"
# }

# # -------------------------------------------
# # Auto Scaling
# # -------------------------------------------

# variable "max_size" {
#   default = 4
# }

# variable "min_size" {
#   default = 1
# }

# variable "desired_capacity" {
#   default = 1
# }

# variable "asg_health_check_type" {
#   default = "ELB"
# }

# variable "target_group_arns" {
#   default = []
# }

