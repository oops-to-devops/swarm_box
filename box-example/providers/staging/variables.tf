variable "vpc_name" {
  default = "Default VPC"
  description = "name of the instance's VPC"
}

variable "subnet_name" {
  default = "Default subnet 1"
  description = "name of the subnet to put instance into"
}

variable "security_group_name" {
  default = "bastion"
  description = "Security group to associate instance with"
}

locals {

  project = "demo-swarm"
  env     = lookup(var.workspace_to_environment_map, terraform.workspace, "staging")
  region  = var.environment_to_region_map[local.env]

  pubsubnets_ids = [data.aws_subnet.pub_subnet1.id]


  app_instance_profile = var.environment_to_instance_profile_map[local.env]

  app_instance_type        = var.environment_to_instance_size_map[local.env]
  app_ami                  = data.aws_ami.app_server_ami.image_id
  app_instance_defaultkey  = var.environment_to_keys_map[local.env]
  app_instance_volume_size = var.environment_to_instance_disk_map[local.env]

  app_eip_needed = var.environment_to_fixedip_map[local.env]

  app_availability_zone_1 = var.environment_to_availability_zone_1[local.env]
  app_availability_zone_2 = var.environment_to_availability_zone_2[local.env]


  app_monitoring_boxes = [
  ]

  common_tags = map(
    "Environment", local.env,
    "Project", local.project
  )

}
