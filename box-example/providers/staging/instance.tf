resource "aws_instance" "swarm_master" {
  ami                         = local.app_ami
  availability_zone           = local.app_availability_zone_1
  ebs_optimized               = false
  instance_type               = "t3.small"
  monitoring                  = false
  key_name                    = local.app_instance_defaultkey
  subnet_id                   = data.aws_subnet.pub_subnet1.id
  vpc_security_group_ids      = [aws_security_group.swarm_demo.id, data.aws_security_group.sg-bastion.id]
  associate_public_ip_address = true

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 60
    delete_on_termination = true
  }

  tags = {
    Environment = local.env
    Name        = "swarm_master"
    Role        = "swarm_master"
    Project     = local.project
  }
}

resource "aws_instance" "swarm_worker" {
  ami                         = local.app_ami
  availability_zone           = local.app_availability_zone_1
  ebs_optimized               = false
  instance_type               = "t3.small"
  monitoring                  = false
  key_name                    = local.app_instance_defaultkey
  subnet_id                   = data.aws_subnet.pub_subnet1.id
  vpc_security_group_ids      = [aws_security_group.swarm_demo.id, data.aws_security_group.sg-bastion.id]
  associate_public_ip_address = true

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 60
    delete_on_termination = true
  }

  tags = {
    Environment = local.env
    Name        = "swarm_worker"
    Role        = "swarm_worker"
    Project     = local.project
  }
}


resource "aws_security_group" "swarm_demo" {

  name        = "${local.project}-${local.env}-app"
  vpc_id      = data.aws_vpc.app_vpc.id
  description = "${local.project} ${local.env} appservers (monitoring, http, https, ssh)"


  # cross communication
  ingress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      self = true
    }

    ingress {
      from_port   = 24007
      to_port     = 24007
      protocol    = "tcp"
      self = true
      description = "Gluster Daemon"
    }

    ingress {
      from_port   = 24008
      to_port     = 24008
      protocol    = "tcp"
      self = true
      description = "Gluster Management"
    }

    ingress {
      from_port   = 38465
      to_port     = 38467
      protocol    = "tcp"
      self = true
      description = "Gluster NFS service"
    }

    ingress {
      from_port   = 49152
      to_port     = 65535
      protocol    = "tcp"
      self = true
      description = "For every new brick, one new port will be used starting at 49152"
    }

    ingress {
      from_port   = 111
      to_port     = 111
      protocol    = "tcp"
      self = true
      description = "Gluster portmapper / tcp"
    }

      ingress {
      from_port   = 111
      to_port     = 111
      protocol    = "udp"
      self = true
      description = "Gluster portmapper / udp"
    }

  # Internal HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Internal HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #ssh from anywhere (unnecessary)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # ping access from anywhere
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = local.env
    Project     = local.project
  }
}