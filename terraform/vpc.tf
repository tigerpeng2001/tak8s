############
## VPC
############

resource "aws_vpc" "kubernetes" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name     = "${var.vpc_name}"
    Modifier = "${module.data.caller_arn}"
  }
}

# DHCP Options are not actually required, being identical to the Default Option Set
resource "aws_vpc_dhcp_options" "dns_resolver" {
  domain_name         = "ec2.internal"
  domain_name         = "${module.data.region == "us-east-1" ? "ec2" : module.data.region}${module.data.region == "us-east-1" ? "" : ".compute"}.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags {
    Name     = "${var.vpc_name}"
    Modifier = "${module.data.caller_arn}"
  }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = "${aws_vpc.kubernetes.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.dns_resolver.id}"
}

##########                                                                       
# Keypair                                                                        
##########                                                                       

resource "aws_key_pair" "default_keypair" {
  key_name   = "${var.default_keypair_name}"
  public_key = "${var.default_keypair_public_key}"
}

############
## Subnets
############

# Subnet (public)
resource "aws_subnet" "kubernetes" {
  count             = "${length(var.zones)}"
  vpc_id            = "${aws_vpc.kubernetes.id}"
  cidr_block        = "${var.vpc_cidr}"
  cidr_block        = "${var.public_subnet_cidr["${element(var.zones,count.index)}"]}"
  availability_zone = "${module.data.region}${element(var.zones,count.index)}"

  tags {
    Name     = "tak8s-public-${element(var.zones,count.index)}"
    Modifier = "${module.data.caller_arn}"
  }
}
