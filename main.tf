/**************************************************************************

# Overview:
  This module creates a redis cluster

Inputs:
  Required:
    cluster_name - name of cluster.  Should contain only lower case letters and '-'
    security_group_ids - comma seperated list of security group ids which are allowed to access this Redis cluster
    subnet_ids - comma seperated list of subnet ids available to this Redis cluster
    vpc_id - VPC id for this Redis cluster

  Optional:
    node_type - type of node to use. defaults to cache.m1.small
    port - port to run on.  defaults to 11211
    count - number of nodes in the cluster.  defaults to 1

Outputs:
  url - url for the Redis cluster
  port - port the Redis cluster is configured on
  security_group_id - security group assigned to the cluster

**************************************************************************/


#
# Module Inputs
#
variable "cluster_name" {}
variable "security_group_ids" {}
variable "subnet_ids" {}
variable "vpc_id" {}

variable "node_type" { default = "cache.m1.small" }
variable "port" { default = "6379" }
variable "count" { default = "1" }


#
# Setup
#
module "elasticache_setup" {
  source = "github.com/mondorobot/terraform-elasticache"
  cluster_name = "${var.cluster_name}-memcached"
  subnet_ids = "${var.subnet_ids}"
  vpc_id = "${var.vpc_id}"
  port = "${var.port}"
  security_group_ids = "${var.security_group_ids}"
}

resource "aws_elasticache_cluster" "redis-server" {
  cluster_id = "${var.cluster_name}"
  engine = "redis"
  engine_version = "2.8.19"
  node_type = "${var.node_type}"
  port = "${var.port}"
  num_cache_nodes = "${var.count}"
  parameter_group_name = "default.redis2.8"
  subnet_group_name = "${module.elasticache_setup.subnet_group_name}"
  apply_immediately = true
  security_group_ids = ["${module.elasticache_setup.security_group_id}"]
}


#
# Module Outputs
#
output "url" {
  value = "${aws_elasticache_cluster.redis-server.cache_nodes.0.address}"
}

output "port" {
  value = "${aws_elasticache_cluster.redis-server.cache_nodes.0.port}"
}

output "security_group_id" {
  value = "${module.elasticache_setup.security_group_id}"
}
