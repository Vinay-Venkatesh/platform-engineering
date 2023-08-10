variable "vpc_id" {
  type = string
  default = "vpc-02256b41e47f3140e"
}

variable "vpc_cidr" {
  type = list(string)
  default = ["10.0.0.0/16"]
}


variable "subnet_ids" {
    type = list(string)
    default = ["subnet-0226738bacb3586e9", "subnet-0088eb2eb35b31452"]
}

variable "eks_managed_node_group_defaults_disk_size" {
    type = number
    default = 20
}

variable "instance_types" {
    type = list(string)
    default = ["t2.micro","t3.micro"]
}

variable "tags" {
    type = map(string)
}

variable "cluster_name" {
    type    = string
    default = "core-service"
}

