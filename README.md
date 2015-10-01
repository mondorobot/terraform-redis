# Terraform Redis Module

## Overview:
This Terraform module launches and configures a redis cluster.

---

#### Required Inputs:
  * cluster_name - name of cluster.  Should contain only lower case letters and '-'
  * security_group_ids - comma seperated list of security group ids which are allowed to * access this Redis cluster
  * subnet_ids - comma seperated list of subnet ids available to this Redis cluster
  * vpc_id - VPC id for this Redis cluster

#### Optional Inputs:
  * node_type - type of node to use. defaults to cache.m1.small
  * port - port to run on.  defaults to 11211
  * count - number of nodes in the cluster.  defaults to 1

#### Outputs:
  * url - url for the Redis cluster
  * port - port the Redis cluster is configured on
  * security_group_id - security group assigned to the cluster
