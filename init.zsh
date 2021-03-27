
######################################################################
#<
#
# Function: p6df::modules::p6kubernetes::deps()
#
#>
######################################################################
p6df::modules::p6kubernetes::deps() {
  ModuleDeps=(
    p6m7g8/p6common
  )
}

######################################################################
#<
#
# Function: p6df::modules::p6kubernetes::init()
#
#>
######################################################################
p6df::modules::p6kubernetes::init() { }

######################################################################
#<
#
# Function: p6_kubernetes_prompt_info()
#
#  Returns:
#	str - str
#
#>
######################################################################
p6_kubernetes_prompt_info() {

    local str

    if ! p6_string_blank "$KUBECONFIG"; then
      str="kube:     "
    fi
    if ! p6_string_blank "$P6_KUBE_CFG"; then
      str="${str}ctx=[$P6_KUBE_CFG]"
    fi
    if ! p6_string_blank "$P6_KUBE_NS"; then
      str="${str} ns=[$P6_KUBE_NS]"
    fi

    if p6_string_blank "$str"; then
      p6_return_void
    else
      p6_return_str "$str"
    fi
}

######################################################################
#<
#
# Function: p6_kubernetes_deployment_of_image(image)
#
#  Args:
#	image -
#
#>
######################################################################
p6_kubernetes_deployment_of_image() {
  local image="$1"

  local str
  str=$(p6_template_process "$P6_DFZ_SRC_P6M7G8_DIR/p6kubernetes/share/deployment.yaml" "IMAGE=$image")

  local dir=$(p6_transient_create "p6_template")
  local outfile="$dir/outfile"
  p6_file_write "$outfile" "$str"
  p6_run_code "kubectl apply -f $outfile"
  p6_transient_delete "$dir"
}
