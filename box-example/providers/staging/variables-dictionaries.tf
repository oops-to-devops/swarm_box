variable "workspace_to_environment_map" {
  type = map(string)
  default = {
    default = "staging"
    dev     = "dev"
    qa      = "qa"
    staging = "staging"
    prod    = "prod"
  }
}

variable "environment_to_instance_size_map" {
  type = map(string)
  default = {
    default = "t3.small"
    dev     = "t3.small"
    qa      = "t3.small"
    staging = "t3.small"
    prod    = "t3.medium"
  }
}

variable "environment_to_instance_disk_map" {
  type = map(string)
  default = {
    default = "30"
    dev     = "30"
    qa      = "35"
    staging = "30"
    prod    = "35"
  }
}

variable "environment_to_fixedip_map" {
  type = map(string)
  default = {
    default = "false"
    dev     = "false"
    qa      = "false"
    staging = "false"
    prod    = "false"
  }
}

variable "environment_to_region_map" {
  type = map(any)
  default = {
    default = "eu-west-1"
    dev     = "eu-west-1"
    qa      = "eu-west-1"
    staging = "eu-west-1"
    prod    = "eu-west-1"
  }
}

variable "environment_to_keys_map" {
  type = map(any)
  default = {
    default = "voronenko_info"
    dev     = "voronenko_info"
    qa      = "voronenko_info"
    staging = "voronenko_info"
    prod    = "voronenko_info"
  }
}

variable "environment_to_instance_profile_map" {
  type = map(any)
  default = {
    default = "web_instance_profile_development"
    dev     = "web_instance_profile_development"
    qa      = "web_instance_profile_development"
    staging = "web_instance_profile_development"
    prod    = "web_instance_profile_production"
  }
}


variable "environment_to_availability_zone_1" {
  type = map(any)
  default = {
    default = "eu-west-1c"
    dev     = "eu-west-1c"
    qa      = "eu-west-1c"
    staging = "eu-west-1c"
    prod    = "eu-west-1c"
  }
}

variable "environment_to_availability_zone_2" {
  type = map(any)
  default = {
    default = "eu-west-1b"
    dev     = "eu-west-1b"
    qa      = "eu-west-1b"
    staging = "eu-west-1b"
    prod    = "eu-west-1b"
  }
}
