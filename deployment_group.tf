resource "aws_codedeploy_deployment_group" "deployment_group" {
  app_name              = aws_codedeploy_app.codedeploy_app.name
  deployment_group_name = aws_codedeploy_app.codedeploy_app.name
  service_role_arn      = data.aws_iam_role.iam_role_codedeploy.arn
  autoscaling_groups    = var.autoscaling_group
  ############################################################
  # Events- "DEPLOYMENT_FAILURE" and "DEPLOYMENT_STOP_ON_ALARM"
  ############################################################

  auto_rollback_configuration {
    enabled = var.rollback_enabled
    events  = var.rollback_events
  }

  ############################################################
  # Deployment Style - In-Place or Blue-Green Deployment
  ############################################################

  deployment_style {
    deployment_option = var.alb_target_group == null ? "WITHOUT_TRAFFIC_CONTROL" : "WITH_TRAFFIC_CONTROL"
    deployment_type   = var.enable_bluegreen == false ? "IN_PLACE" : "BLUE_GREEN"
  }


  ############################################################
  # Deployment Style -Blue-Green Deployment Configuration
  ############################################################

  dynamic "blue_green_deployment_config" {
    for_each = var.enable_bluegreen == true ? [1] : []
    content {
      deployment_ready_option {
        action_on_timeout    = var.bluegreen_timeout_action
        wait_time_in_minutes = var.bluegreen_timeout_action == "STOP_DEPLOYMENT" ? 5 : null
      }

      terminate_blue_instances_on_deployment_success {
        action                           = var.blue_termination_behavior
        termination_wait_time_in_minutes = var.blue_termination_behavior == "TERMINATE" ? 5 : null
      }
      green_fleet_provisioning_option {
        action = var.green_provisioning
      }
    }
  }

  ############################################################
  # Deployment Style -Blue-Green Deployment Configuration
  ############################################################

  dynamic "load_balancer_info" {
    for_each = var.alb_target_group == null ? [] : [var.alb_target_group]
    content {
      target_group_info {
        name = var.alb_target_group
      }
      #   target_group_pair_info {
      #       name = 
      #   }
    }
  }

  #############################################################
  ## Trigger Configuration
  #############################################################

  dynamic "trigger_configuration" {
    for_each = var.trigger_target_arn == null ? [] : [var.trigger_target_arn]
    content {
      trigger_events     = var.trigger_events
      trigger_name       = "${var.app_name}-${var.environment}"
      trigger_target_arn = var.trigger_target_arn
    }
  }

  ####################################################################
  ## EC2 Tags for filter to deploy
  ####################################################################

  ec2_tag_filter {
    key   = "Name"
    type  = "KEY_AND_VALUE"
    value = "asg"
  }

  depends_on = [
    aws_codedeploy_app.codedeploy_app,
  ]
}