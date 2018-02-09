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
  domain_name = "${module.data.region}.compute.internal"                                 
  domain_name_servers = ["AmazonProvidedDNS"]                                    
                                                                                 
  tags {                                                                         
    Name = "${var.vpc_name}"                                                     
    Modifier = "${module.data.caller_arn}" 
  }                                                                              
} 

resource "aws_vpc_dhcp_options_association" "dns_resolver" {                     
  vpc_id ="${aws_vpc.kubernetes.id}"                                             
  dhcp_options_id = "${aws_vpc_dhcp_options.dns_resolver.id}"                    
}                                                                                
