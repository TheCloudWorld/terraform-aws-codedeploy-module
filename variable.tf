variable "compute_platform_target" {
  description = "'Server', 'Lambda' and 'ECS'. Select anyone value"
  type        = string
  default     = "Server"
}
variable "codedeploy_app_name" {
  description = "Enter the name for codedeploy app"
  type        = string
  default     = "myApp"
}
variable "codedeploy_app_tag_name" {
  type    = string
  default = "myApp"
}
variable "deployment_config_name" {
  type    = string
  default = "config_name"
}
variable "environment" {
  description = "Environment where your codedeploy deployment group is used for"
  type        = string
  default     = "dev"
}

variable "app_name" {
  description = "in-place"
  type        = string
  default     = "myApp"
}

# variable "service_role_arn" {
#   description = "IAM role that is used by the deployment group"
#   default     = "arn:aws:iam::872019428947:role/codedeploytolambda"
# }

variable "autoscaling_group" {
  type        = list(string)
  description = "Autoscaling groups you want to attach to the deployment group"
  #default     = ["as"]
  default = null
}

variable "rollback_enabled" {
  description = "Whether to enable auto rollback"
  default     = false
}

variable "rollback_events" {
  description = "The event types that trigger a rollback"
  type        = list(string)
  default     = ["DEPLOYMENT_FAILURE"]
}

variable "trigger_events" {
  description = "events that can trigger the notifications"
  type        = list(string)
  default     = ["DeploymentStop", "DeploymentRollback", "DeploymentSuccess", "DeploymentFailure", "DeploymentStart"]
}

variable "trigger_target_arn" {
  description = "The ARN of the SNS topic through which notifications are sent"
  type        = string
  default     = null
}

variable "enable_bluegreen" {
  description = "Enable all bluegreen deployment options"
  type        = bool
  default     = false

}

variable "bluegreen_timeout_action" {
  description = "When to reroute traffic from an original environment to a replacement environment. Only relevant when `enable_bluegreen` is `true`"
  type        = string
  default     = "CONTINUE_DEPLOYMENT"
}

variable "blue_termination_behavior" {
  description = " The action to take on instances in the original environment after a successful deployment. Only relevant when `enable_bluegreen` is `true`"
  default     = "TERMINATE"
}

variable "green_provisioning" {
  description = "The method used to add instances to a replacement environment. Only relevant when `enable_bluegreen` is `true`"
  type        = string
  default     = "COPY_AUTO_SCALING_GROUP"
}

variable "alb_target_group" {
  description = "Name of the ALB target group to use, define it when traffic need to be blocked from ALB during deployment"
  type        = string
  default     = null
}

variable "ec2_tag_filter" {
  description = "Filter key and value you want to use for tags filters. Defined as key/value format, example: `{\"Environment\":\"staging\"}`"
  type        = map(string)
  default = {
    "Name" = "dev"
  }
}
variable "routing_traffic_config" {
  description = "TimeBasedCanary, TimeBasedLinear, AllAtOnce"
  type        = string
  default     = "AllAtOnce"
}
variable "minimum_healthy_hosts_type" {
  description = "FLEET_PERCENT, HOST_COUNT"
  type        = string
  default     = "HOST_COUNT"
}
variable "minimum_healthy_hosts_number" {
  description = "Enter value in number or percentage. Number for HOST_COUNT & Percentage for FLEET_PERCENT"
  type        = number
  default     = 1
}
variable "canary_based_interval" {
  description = "The number of minutes between the first and second traffic shifts of a TimeBasedCanary deployment."
  type        = number
  default     = 30
}
variable "canary_based_percentage" {
  description = "The percentage of traffic to shift in the first increment of a TimeBasedCanary deployment"
  type        = number
  default     = 50
}
variable "linear_based_ineterval" {
  description = "The number of minutes between each incremental traffic shift of a TimeBasedLinear deployment."
  type        = number
  default     = 30
}
variable "linear_based_percentage" {
  description = "The percentage of traffic that is shifted at the start of each increment of a TimeBasedLinear deployment."
  type        = number
  default     = 50
}
variable "compute_plat" {
  description = "'Server', 'Lambda' and 'Ecs'. select any of three"
  type        = string
  default     = "Server"
}
variable "routing_traffic_config_required" {
  description = "Routing traffic configuration required or not"
  type        = bool
  default     = true
}
variable "create_deployment_config" {
  description = "Whether manual routing configuration required"
  type        = bool
  default     = true
}
variable "codedeploy_app_and_group_name" {
  type    = string
  default = "codedeploy"
}