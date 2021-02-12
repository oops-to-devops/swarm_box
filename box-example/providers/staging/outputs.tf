# COMMENT CONTENTS OF THIS FILE
# DURING DOING DESTROY OPERATION

locals {

  aws_region_env_yml = <<YAML

option_enforce_ssh_keys_login: false
option_ufw: false
box_deploy_user: ubuntu

# terraform managed
# This file was generated by terraform for workspace ${terraform.workspace}

aws_vpc_id: ${data.aws_vpc.app_vpc.id}

aws_vpc_pubsubnet1: ${data.aws_subnet.pub_subnet1.id}
vpc_availability_zone_t1: "${local.app_availability_zone_1}"
vpc_availability_zone_t2: "${local.app_availability_zone_2}"

env_aws_region: "${local.region}"

# naming facts
name_appserver_0: "${local.project}-${local.env}-app-0"

YAML

  envvars = <<ENVVARS
#!/bin/bash

INFRASTRUCTURE_ROOT_DIR=$(
  cd $(dirname "$0")
  pwd
)
export REMOTE_HOST=$INFRASTRUCTURE_ROOT_DIR/provisioners/shared/inventory/${local.env}
export ENV_INVENTORY=$INFRASTRUCTURE_ROOT_DIR/provisioners/shared/inventory/${local.env}
export ANSIBLE_INVENTORY=$ENV_INVENTORY
export REMOTE_USER_INITIAL=ubuntu
export REMOTE_PASSWORD_INITIAL=
export BOX_DEPLOY_USER=ubuntu
export ENVIRONMENT=${local.env}
export PROVIDER=aws
# if you use sudo
export BOX_DEPLOY_PASS=
#export ANSIBLE_VAULT_IDENTITY=@$HOME/PASSHERE/vault_pass.txt

ENVVARS

  inventory_ec2 = <<INVENTORYEC2
all: # keys must be unique, i.e. only one 'hosts' per group
    hosts:
        master:
            ansible_host: ${aws_instance.swarm_master.public_ip}
            ansible_user: ubuntu
        worker:
            ansible_host: ${aws_instance.swarm_worker.public_ip}
            ansible_user: ubuntu
    vars:
        group_var1: value2

    vars:
        group_all_var: value
    children:   # key order does not matter, indentation does
        swarm_master:
            hosts:
                master # same host as above, additional group membership
            vars:
                group_last_var: value
        swarm_managers:
        swarm_workers:
            hosts:
                worker # same host as above, additional group membership
            vars:
                group_last_var: value
        docker_box:
            hosts:
                master:
                worker:
        glusterfs_box:
            hosts:
                master:
                worker:

INVENTORYEC2

  provisioningscript = <<PROVISIONINGSCRIPT
#!/bin/bash
echo "Note: This script is supposed to be sourced.  .<FILE> or source <FILE> , depending on shell used"
# first import shared envvars if needed ...
cd $INFRASTRUCTURE_ROOT_DIR/provisioners/app-test
./p_aws.sh

PROVISIONINGSCRIPT

  help = <<HELP
terraform output aws_region_env_yml
terraform output envvars
terraform output inventory_simple
terraform output inventory_ec2
terraform output provisioningscript
HELP
}



output "aws_region_env_yml" {
  value = local.aws_region_env_yml
}

output "inventory_ec2" {
  value = local.inventory_ec2
}

output "envvars" {
  value = local.envvars
}

output "provisioningscript" {
  value = local.provisioningscript
}

output "help" {
  value = local.help
}


resource "local_file" "shared_provider_vars" {
  content         = local.aws_region_env_yml
  filename        = "${path.root}/../../provisioners/shared/providers/aws-${local.env}-vars.yml"
  file_permission = "0644"
}

resource "local_file" "shared_inventory_ec2" {
  content         = local.inventory_ec2
  filename        = "${path.root}/../../provisioners/shared/inventory/${local.env}/inventory.yml"
  file_permission = "0644"
}

resource "local_file" "shared_envvars" {
  content         = local.envvars
  filename        = "${path.root}/../../local_${local.env}.sh"
  file_permission = "0644"
}
