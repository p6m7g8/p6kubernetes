######################################################################
#<
#
# Function: p6df::modules::p6kubernetes::version()
#
#>
######################################################################
p6df::modules::p6kubernetes::version() { echo "0.0.1"; }

######################################################################
#<
#
# Function: p6df::modules::p6kubernetes::deps()
#
#>
######################################################################
p6df::modules::p6kubernetes::deps() { ModuleDeps=() }

######################################################################
#<
#
# Function: p6df::modules::p6kubernetes::init()
#
#>
######################################################################
p6df::modules::p6kubernetes::init() { }

# p6kubernetes
######################################################################
#<
#
# Function: p6_kubernetes_cluster_create(cluster_name, [cluster_version=1.17], [vpc_id=$AWS_VPC_ID])
#
#  Args:
#	cluster_name - 
#	OPTIONAL cluster_version -  [1.17]
#	OPTIONAL vpc_id -  [$AWS_VPC_ID]
#
#>
######################################################################
p6_kubernetes_cluster_create() {
  local cluster_name="$1"
  local cluster_version="${2:-1.17}"
  local vpc_id="${3:-$AWS_VPC_ID}"

  local private_subnets
  local public_sunets

  eksctl create cluster \
    --name "$cluster_name" \
    --version "$cluster_version" \
    --without-nodegroup \
    --vpc-private-subnets "$private_subnets" \
    --vpc-public-subnets "$public_subnets"
}

# p6aws/lib/svc/eks
######################################################################
#<
#
# Function: p6_kubernetes_aws_cluster_logging_enable([cluster_name=$KUBE_CLUSTER_NAME])
#
#  Args:
#	OPTIONAL cluster_name -  [$KUBE_CLUSTER_NAME]
#
#>
######################################################################
p6_kubernetes_aws_cluster_logging_enable() {
  local cluster_name="${1:-$KUBE_CLUSTER_NAME}"

  aws eks update-cluster-config \
    --name "$cluster_name" \
    --logging '{"clusterLogging":[{"types":["api","audit","authenticator","controllerManager","scheduler"],"enabled":true}]}'
}

# ALB Ingress Controller Only
######################################################################
#<
#
# Function: p6_kubernetes_aws_cluster_fargate_profile_create([cluster_name=$KUBE_CLUSTER_NAME], profile_name, namespace)
#
#  Args:
#	OPTIONAL cluster_name -  [$KUBE_CLUSTER_NAME]
#	profile_name - 
#	namespace - 
#
#>
######################################################################
p6_kubernetes_aws_cluster_fargate_profile_create() {
  local cluster_name="${1:-$KUBE_CLUSTER_NAME}"
  local profile_name="$2"
  local namespace="$3"

  # XXX: use config file with templates for multiple namespaces
  eksctl create fargateprofile \
    --cluster "$cluster_name" \
    --name "$profile_name" \
    --namespace "$namespace"
}

# NLB
######################################################################
#<
#
# Function: p6_kunernetes_nodegroup_create([cluster_name=$KUBE_CLUSTER_NAME], profile_name)
#
#  Args:
#	OPTIONAL cluster_name -  [$KUBE_CLUSTER_NAME]
#	profile_name - 
#
#>
######################################################################
p6_kunernetes_nodegroup_create() {
  local cluster_name="${1:-$KUBE_CLUSTER_NAME}"
  local profile_name="$2"

  eksctl create nodegroup \
    --cluster $cluster_name \
    --name $profile_name \
    --managed \
    --node-type m5.large \
    --nodes 3 \
    --nodes-min 2 \
    --nodes-max 4
}
