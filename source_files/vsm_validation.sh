#!/bin/bash

validateNetworks(){
	#neutron_listNetNames=$(neutron  --os-tenant-name $1 --os-username $1 --os-password $default_pwd net-list | grep -i -v ext | grep "net-t[0-9]" | cut -d "|" -f 3)
	#neutron_listNetNames=$(neutron  --os-tenant-name $1 --os-username $1 --os-password $default_pwd net-list | grep net["1","-"] | cut -d "|" -f 3 | sort)
	#vsm_listNetNames=$(cat ./outputs/show_nsm_nw_seg | grep Description | cut -d ":" -f 2 | sort )

	#for nname in $neutron_listNetNames; do
	#	for vname in $vsm_listNetNames; do
	#		if [ "$nname" == "$vname" ]; then
	#			echo "1" $nname $vname
	#			continue
	#		else
	#			echo "2" $nname $vname
	#			#echo "Error: Networks created on VSM and Neutron do not match."
	#			continue
	#		fi
	#	done
	#done
	#echo "Success: Networks created on VSM and Neutron are in sync."
	
	neutron_NetCount=$(neutron  --os-tenant-name $1 --os-username $1 --os-password $default_pwd net-list | grep "net-t[0-9]" | wc -l)
	vsm_NetCount=$(cat ./outputs/show_nsm_nw_seg | grep "Description" | grep "net-t[0-9]" | wc -l)
	
	if [ $neutron_NetCount -eq $vsm_NetCount ]; then 
		echo "Success: Networks created on VSM ($vsm_NetCount) and Neutron ($neutron_NetCount) are in sync."
	else
		echo "Error: Networks created on VSM ($vsm_NetCount) and Neutron ($neutron_NetCount) do not match."
	fi	
}


validateSubnets(){
	neutron_SubnetCount=$(neutron  --os-tenant-name $1 --os-username $1 --os-password $default_pwd subnet-list | grep "subnet-t[0-9]" | wc -l)
	vsm_SubnetCount=$(cat ./outputs/show_nsm_ip_pool | grep "Description" | grep "subnet-t[0-9]" | wc -l)
	
	if [ $neutron_SubnetCount -eq $vsm_SubnetCount ]; then 
		echo "Success: IP pool templates created on VSM ($vsm_SubnetCount) and subnets created on Neutron ($neutron_SubnetCount) are in sync."
	else
		echo "Error: IP pool templates created on VSM ($vsm_SubnetCount) and subnets created on Neutron ($neutron_SubnetCount) do not match."
	fi	
}


validateVethernet(){

	neutron_PortCount=$(neutron  --os-tenant-name $1 --os-username $1 --os-password $default_pwd port-list | cut -d "|" -f 2 | grep [0-9] | wc -l)
	vsm_PortCount=$(cat ./outputs/show_nsm_nw_veth | grep vmn_ | wc -l)
	
	if [ $neutron_PortCount -eq $vsm_PortCount ]; then 
		echo "Success: Vethernet networks created on VSM ($vsm_PortCount) and ports on Neutron ($neutron_PortCount) are in sync."
	else
		echo "Error: Vethernet networks created on VSM ($vsm_PortCount) and ports on Neutron ($neutron_PortCount) do not match."
	fi	
}
