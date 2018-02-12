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
resource "aws_subnet" "kubernetes_pub" {
  count             = "${length(var.zones)}"
  vpc_id            = "${aws_vpc.kubernetes.id}"
  cidr_block        = "${var.vpc_cidr}"
  cidr_block        = "${var.public_subnet_cidr["${element(var.zones,count.index)}"]}"
  availability_zone = "${module.data.region}${element(var.zones,count.index)}"

  tags {
    Name     = "${var.vpc_name}-public-${element(var.zones,count.index)}"
    Modifier = "${module.data.caller_arn}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.kubernetes.id}"

  tags {
    Name     = "${var.vpc_name}-igw-${element(var.zones,count.index)}"
    Modifier = "${module.data.caller_arn}"
  }
}

############
## Routing
############

resource "aws_route_table" "kubernetes" {
  count  = "${length(var.zones)}"
  vpc_id = "${aws_vpc.kubernetes.id}"

  # Default route through Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name     = "${var.vpc_name}-igw-${element(var.zones,count.index)}"
    Modifier = "${module.data.caller_arn}"
  }
}

resource "aws_route_table_association" "kubernetes" {
  #  count             = "${length(var.zones)}" 
  #  subnet_id = "${aws_subnet.kubernetes["${count.index}"].id}"
  #  route_table_id = "${aws_route_table.kubernetes["${count.index}"].id}"
  subnet_id = "${aws_subnet.kubernetes.id[0]}"

  route_table_id = "${aws_route_table.kubernetes.id[0]}"
}
