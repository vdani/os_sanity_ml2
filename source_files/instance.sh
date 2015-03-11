#!/bin/bash
source ./source_files/utility.sh
source ./source_files/handle_error.sh

launchVM(){
	imageID=$(nova --os-tenant-name $admin_tenant --os-username $admin_uname --os-password $default_pwd image-list | grep -i cirros | cut -d "|" -f 2)
	flavorID=$(nova --os-tenant-name $admin_tenant --os-username $admin_uname --os-password $default_pwd flavor-list | grep m1.small | cut -d "|" -f 2 | xargs)
	listPortID=$(neutron  --os-tenant-name $1 --os-username $1 --os-password $default_pwd port-list | cut -d "|" -f 2 | grep [0-9])
	local i=1
        for portID in $listPortID; do
     	   	if [ "$(neutron  --os-tenant-name $1 --os-username $1 --os-password $default_pwd port-show $portID | grep network:dhcp | cut -d "|" -f 3 | xargs)" == "network:dhcp" ]; then
        	        continue
       	   	fi
   		echo "Executing for $1: nova boot --image $imageID --flavor $flavorID --nic port-id=$portID vm-$i"
		getTimeStamp
        	if ! nova --os-tenant-name $1 --os-username $1 --os-password $default_pwd boot --image $imageID --flavor $flavorID --nic port-id=$portID vm-$i; then
                	handle_nova_error
			echo "FAILED  : Execution for $1: nova boot --image $imageID --flavor $flavorID --nic port-id=$portID vm-$i" >> execution_summary_tenant
                	exit 1
        	fi
		echo "SUCCESS : Execution for $1: nova boot --image $imageID --flavor $flavorID --nic port-id=$portID vm-$i" >> execution_summary_tenant
		echo "Sleeping for $pause seconds..."
		sleep $pause 
		(( i++ ))
 	done
}

listVM(){
	echo "Executing for tenant-$1: nova list"
	getTimeStamp
        if ! nova --os-tenant-name $1 --os-username $1 --os-password $default_pwd list; then
		handle_nova_error
		echo "FAILED  : Execution for tenant-$1: nova list" >> execution_summary_tenant
                exit 1
	fi
	echo "SUCCESS : Execution for tenant-$1: nova list" >> execution_summary_tenant
	echo "Sleeping for $pause seconds..."
        sleep $pause 
}

deleteVM(){
	listVMID=$(nova --os-tenant-name $1 --os-username $1 --os-password $default_pwd list | cut -d "|" -f 2 | grep [0-9])
	for vmID in $listVMID; do
   		echo "Executing for tenant-$1: nova delete $vmID"
		getTimeStamp
		if ! nova --os-tenant-name $1 --os-username $1 --os-password $default_pwd delete $vmID; then
			handle_nova_error
			echo "FAILED  : Execution for tenant-$1: nova delete $vmID" >> execution_summary_tenant
                	exit 1
        	fi
		echo "SUCCESS : Execution for tenant-$1: nova delete $vmID" >> execution_summary_tenant
		echo "Sleeping for $pause seconds..."
		sleep $pause 
  	done
}
