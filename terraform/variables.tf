variable project {
  default = "tak8s"
}

variable vpc_cidr {
  default = "10.89.64.0/24"
}

# prepare for deploy into multiple zone for HA
variable zones {
  description = "one or more zones to deploy the cluster"
  type        = "list"
  default     = ["a"]

  #default     = ["a", "b"]
  #default     = ["a", "b", "c"]
}

# hardcoded here, may use funciont to calculate
variable public_subnet_cidr {
  description = "one or more zones to deploy the cluster"
  type        = "map"

  default = {
    "a" = "10.89.64.0/27"
    "b" = "10.89.64.32/27"
    "c" = "10.89.64.64/27"
  }
}

variable private_subnet_cidr {
  description = "one or more zones to deploy the cluster"
  type        = "map"

  default = {
    "a" = "10.89.64.128/27"
    "b" = "10.89.64.160/27"
    "c" = "10.89.64.192/27"
  }
}

variable vpc_name {
  default = "tak8s"
}

variable default_keypair_public_key {
  description = "Public Key of the default keypair"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDs32g+PpP5AkJ7YGKrC5IyWOselXHn1pKyIy/PD+NW7cipuPjJu711xpQrPmNM+iuf7FsHlPxdaL7pRRKI2m23fy69ZYacil9GRKUK57DJyNkIjyE2u2yHGm9zt3nvAi6OFzPWk7HOCIOw8uhCcxXYta4eMKOFn93EY7TkjE6MxH3K2tfZz5BEA0o7FESxiYymBJcP0WyMGxDY5yK0YUdGsh5nhpwGoFWswHhiEnAMlLXw6jSL4S1fIhoWFgTRcYsFGTvA2qzOfsccC5EwlssGoFRcZiCHNtd6pFxeIOp30qJw6WSvffAzG62OsOxsJqDM2QP0ppbOYaDysz//r5Vl Pair to tpeng@OAVHN3V8DV33s-MacBook-Pro.local:~/.terraform"
}

variable default_keypair_name {
  description = "Name of the KeyPair used for all nodes"
  default     = "tak8s"
}
