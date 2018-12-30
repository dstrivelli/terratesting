########################
#  Security Group Vars #
########################

variable "sg_name" {
  default = "Simple Security Group"
}

variable "sg_description" {
  default = "Egress all, ingress 22/80"
}

variable "sg_vpc_id" {
  default = "vpc-7d5fe807"
}

#########################
#   App Load Balancer   #
#########################

variable "alb_sgs" {
  default = ["sg-21c92e63"]
}

variable "alb_subnets" {
  default = ["subnet-113a5b3f", "subnet-34507a7e", "subnet-b7f195eb", "subnet-e1efb2ee", "subnet-ebf55bd5", "subnet-f034af97"]
}

variable "alb_idle_timeout" {
  default = 60
}

variable "alb_internal" {
  default = false
}

variable "alb_name" {
  default = "MY-ALB"
}

variable "alb_deletion_protection" {
  default = false
}

#########################
#    LB Target Group    #
#########################

variable "lb_tg_name" {
  default = "MY-ALB-TG"
}

variable "lb_tg_port" {
  default = 80
}

variable "lb_tg_protocol" {
  default = "HTTP"
}

#########################
#      LB Listener      #
#########################

variable "lb_listener_port" {
  default = 80
}

variable "lb_listener_action_type" {
  default = "forward"
}

#########################
# Listener Health Check #
#########################

variable "hc_healthy_threshold" {
  default = 2
}

variable "hc_unhealthy_threshold" {
  default = 2
}

variable "hc_timeout" {
  default = 3
}

variable "hc_path" {
  default = "/"
}

variable "hc_interval" {
  default = 30
}

variable "hc_matcher" {
  default = "200"
}

#########################
# Launch Configuration  #
#########################

variable "lc_name" {
  default = "echo-launch-configuration"
}

variable "lc_image_id" {
  default = "ami-0e791d1dfd974a496"
}

variable "lc_instance_type" {
  default = "t2.micro"
}

variable "lc_key_name" {
  default = "dantebellefante"
}

variable "lc_security_groups" {
  default = ["sg-21c92e63"]
}

variable "lc_enable_monitoring" {
  default = false
}

variable "lc_ebs_optimized" {
  default = false
}

variable "lc_volume_type" {
  default = "gp2"
}

variable "lc_volume_size" {
  default = 8
}

variable "lc_delete_on_termination" {
  default = true
}

#########################
#  Auto Scaling Group   #
#########################

variable "asg_desired_capacity" {
  default = 3
}

variable "asg_health_check_grace_period" {
  default = 0
}

variable "asg_health_check_type" {
  default = "EC2"
}

variable "asg_max_size" {
  default = 5
}

variable "asg_min_size" {
  default = 0
}

variable "asg_name" {
  default = "echo-auto-scaling-group"
}

variable "asg_vpc_zone_identifier" {
  default = ["subnet-34507a7e"]
}
