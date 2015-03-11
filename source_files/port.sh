#!/bin/bash
source ./source_files/utility.sh
source ./source_files/handle_error.sh

createPort(){
	listNetID=$(neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd net-list | grep -i -v ext | grep "net-t" | cut -d "|" -f 2 | grep [0-9])
	ppID=$(neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd cisco-policy-profile-list | grep $vm_policy_profile | cut -d "|" -f 2)
   	for netID in $listNetID; do
   		echo "Executing for tenant-$1: neutron port-create $netID --n1kv:profile $ppID"
		getTimeStamp
                if ! neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd port-create $netID --n1kv:profile $ppID; then
                        handle_neutron_error
                        exit 1
                fi
		echo "Sleeping for $pause seconds..."
		sleep $pause
   	done
}


listPort(){
	echo "Executing for tenant-$1: neutron port-list"
	getTimeStamp
        if ! neutron  --os-tenant-name $1 --os-username $1 --os-password $default_pwd port-list; then
                handle_neutron_error
                exit 1
        fi
	echo "Sleeping for $pause seconds..."
	sleep $pause
}

deletePort(){
	listPortID=$(neutron  --os-tenant-name $1 --os-username $1 --os-password $default_pwd port-list | cut -d "|" -f 2 | grep [0-9])
	for portID in $listPortID; do
		if [ "$(neutron  --os-tenant-name $1 --os-username $1 --os-password $default_pwd port-show $portID | grep network:dhcp | cut -d "|" -f 3 | xargs)" == "network:dhcp" ]; then
			continue
		fi
		echo "Executing for tenant-$1: neutron port-delete $portID"
		getTimeStamp
		if ! neutron  --os-tenant-name $1 --os-username $1 --os-password $default_pwd port-delete $portID; then
	                handle_neutron_error
        	        exit 1
       		fi
		echo "Sleeping for $pause seconds..."
		sleep $pause
	done
}
