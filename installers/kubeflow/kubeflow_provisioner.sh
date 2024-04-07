#!/bin/bash
# Purpose: DevOps tools for installing kubeflow on a linux server
# Ref: https://charmed-kubeflow.io/docs/get-started-with-charmed-kubeflow#heading--install-and-prepare-microk8s

error(){
	printf "\033[35mError:\t\033[31m${1}\033[0m\n"
	exit 1
}

logger(){
	msg="${1}"
	printf "LOG:\t${msg}\n"
}

dependency_check(){
	if [ -z "$(command -v juju)" ];
	then
		error "Missing the JUJU application"
	fi
}

remove_kubeflow(){
	if [ -n "$(juju models | egrep 'kubeflow')" ];
	then
		printf "\033[33mRemove, kubeflow model from JuJu\033[0m\n"
		read -p "Are you sure?\n" _confirm
		_confirm=$(printf $confirm | tr [:upper:] [:lower:])
		case $_confirm in
			y|yes) juju destroy-model kubeflow --yes --destroy-storage --force;;
		esac
	else
		logger "Kubeflow model is not installed"
	fi
}

add_to_config(){
	setting="${1}"
	attribute="$(printf ${setting} | cut -d'=' -f1)"
	config="/etc/sysctl.conf"
	printf "\033[35mChecking, ${config} for attribute ${attribute}\033[0m\n"
	if [ -z "$(sudo cat ${config} | egrep ${attribute})" ];
	then
		logger "Adding, ${setting} to ${config}"
		echo ${setting} | sudo tee -a ${config}
	fi
}

install_kubeflow(){
	# Add Kubeflow to JuJu
	if [ -z "$(juju models | egrep 'kubeflow')" ];
	then
		juju add-model kubeflow
		sleep 1
	fi
	juju deploy kubeflow --trust --channel=1.8/stable
	# Add Sysctl setting to configuration
	add_to_config 'fs.inotify.max_user_instances=1280'
	add_to_config 'fs.inotify.max_user_watches=655360'
	logger "Loading, kernel configurations from file"
	sudo sysctl -p
}

configure(){
	# Extract ingress gateway IP Address
	endpoint_ipaddr=$(kubectl -n kubeflow get svc istio-ingressgateway-workload -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
	printf "\033[35mFound, IP Address: \033[32m${endpoint_ipaddr}\033[0m\n"
	# Define endpoint URL
	endpoint_url="http://${endpoint_ipaddr}.nip.io"
	# Add settings to configuration
	juju config dex-auth public-url=${endpoint_url}
	juju config oidc-gatekeeper public-url=${endpoint_url}
	juju config dex-auth static-username=admin
	juju config dex-auth static-password=admin
}

extract_val(){
	arg="${1}"
	_arg=$(printf "${arg}" | cut -d':' -f2 | cut -d'=' -f2)
	printf "${_arg}"
}

help_menu(){
	printf "\033[36mKubeflow Provisioner\033[0m\n"
	printf "\033[35mExecute Step\t\32m[ --step=COMMAND, step:COMMAND ]\n"
	exit 0
}

for argv in $@
do
	case $argv in
		--step=*|step:*) _step=$(extract_val $argv);;
		-h|-help|--help) help_menu;;
	esac
done

case $_step in
	remove)
	dependency_check
	remove_kubeflow
	;;
	install)
	dependency_check
	install_kubeflow
	;;
	configure)
	dependency_check
	configure
	;;
	*) error "Missing or invalid step was given";;
esac
