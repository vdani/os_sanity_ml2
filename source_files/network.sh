#!/bin/bash
source ./source_files/utility.sh
source ./source_files/handle_error.sh

createNW(){
	tenant_nw_octet1=$(echo $tenant_nw | cut -d "." -f 1)
        tenant_nw_octet2=$(echo $tenant_nw | cut -d "." -f 2)
        tenant_nw_octet3=$(echo $tenant_nw | cut -d "." -f 3)
        tenant_nw_octet4=$(echo $tenant_nw | cut -d "." -f 4)
	adder=$(echo "$1" | cut -d "-" -f 2) 
	tenant_nw_octet2=`expr $tenant_nw_octet2 + $adder - 1`
		local i=$adder 
		local k=1
                while [ $k -le $per_tenant_seg_range_size ]
                do
                        data_subnet=$tenant_nw_octet1'.'$tenant_nw_octet2'.'$tenant_nw_octet3'.'$tenant_nw_octet4
                        echo "Executing for $1: neutron net-create net-t$i-s$k"
			getTimeStamp
                        if ! neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd net-create net-t$i-s$k; then
                                handle_neutron_error
                        	echo "FAILED  : Execution for $1: neutron net-create net-t$i-s$k" >> execution_summary_tenant
                                exit 1
                        fi
                        echo "SUCCESS : Execution for $1: neutron net-create net-t$i-s$k" >> execution_summary_tenant
                        sleep $pause
                        echo "Executing for $1: neutron subnet-create net-t$i-s$k  $data_subnet/$tenant_nw_prefix --name subnet-t$i-s$k"
			getTimeStamp
                        if ! neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd subnet-create net-t$i-s$k $data_subnet/$tenant_nw_prefix --name subnet-t$i-s$k --disable-dhcp; then
                                handle_neutron_error
                        	echo "FAILED  : Execution for $1: neutron subnet-create net-t$i-s$k  $data_subnet/$tenant_nw_prefix --name subnet-t$i-s$k" >> execution_summary_tenant
                                exit 1
                        fi
                        echo "SUCCESS : Execution for $1: neutron subnet-create net-t$i-s$k  $data_subnet/$tenant_nw_prefix --name subnet-t$i-s$k" >> execution_summary_tenant
                        sleep $pause
                        (( k++ ))

			if [ $tenant_nw_octet3 -le 254 ]; then
                        	(( tenant_nw_octet3++ ))
			else
				(( tenant_nw_octet2++ ))
				tenant_nw_octet3=1
			fi
                done
        echo "Sleeping for $pause seconds..."
        sleep $pause

}


listNW(){
	echo "Executing for tenant-$1: neutron net-list"
	getTimeStamp
	if ! neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd net-list; then
		handle_neutron_error
		exit 1
	fi
	echo "Executing for tenant-$1: neutron subnet-list"	
	getTimeStamp
	if ! neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd subnet-list; then
		handle_neutron_error
		exit 1
	fi		
	echo "Sleeping for $pause seconds..."
	sleep $pause
}

updateNW(){
                local k=1

                while [ $k -le $range_size ]
                do
                        echo "Executing for tenant-$1: neutron net-update net-t$i-s$k --name mod-net-t$i-s$k"
			getTimeStamp
                        if ! neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd net-update net-t$i-s$k --name mod-net-t$i-s$k; then
                                handle_neutron_error
                                exit 1
                        fi
                        sleep $pause
                        echo "Executing for tenant-$1: neutron subnet-update subnet-t$i-s$k --name mod-subnet-t$i-s$k" 
			getTimeStamp
                        if ! neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd subnet-update subnet-t$i-s$k --name mod-subnet-t$i-s$k; then
                                handle_neutron_error
                                exit 1
                        fi
                        sleep $pause
                        (( k++ ))
                done
 #       done
        echo "Sleeping for $pause seconds..."
        sleep $pause
}

deleteNW(){
	listSubnetID=$(neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd subnet-list | grep -i -v "ext" | grep "subnet-t" | cut -d "|" -f 2 | grep [0-9])
	for subnetID in $listSubnetID; do
		echo "Executing for tenant-$1: neutron subnet-delete $subnetID"
		getTimeStamp
		if ! neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd subnet-delete $subnetID; then
			handle_neutron_error
			exit 1
		fi
		sleep $pause
	done
	echo "Sleeping for $pause seconds..."
	sleep $pause

	listNetID=$(neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd net-list | grep -i -v ext | grep "net-t" | cut -d "|" -f 2 | grep [0-9])
	for netID in $listNetID; do
		echo "Executing for tenant-$1: neutron net-delete $netID"
		getTimeStamp
		if ! neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd net-delete $netID; then
			handle_neutron_error
			exit 1
		fi
		sleep $pause
	done
	echo "Sleeping for $pause seconds..."
	sleep $pause
}

createExtNW(){

# neutron net-create public --router:external True
# $ neutron subnet-create public 172.16.1.0/24
# Put a loop here to do this for range of external networks
# profileID=$(neutron --os-tenant-name $admin_tenant --os-username $admin_uname --os-password $admin_pwd cisco-network-profile-list | grep -i "NP-EXT-NW" | cut -d "|" -f 2 | grep [0-9])

		echo "Executing: neutron net-create NET-EXT-NW --provider:network_type vlan --provider:segmentation_id $ext_nw_vlan --provider:physical_network $phy_net --router:external True"
               	getTimeStamp
		 if ! neutron --os-tenant-name $admin_tenant --os-username $admin_uname --os-password $default_pwd net-create NET-EXT-NW  --provider:network_type vlan --provider:segmentation_id $ext_nw_vlan --provider:physical_network $phy_net --router:external True; then
                        handle_neutron_error
                        exit 1
                fi
                sleep $pause

                echo "Executing: neutron subnet-create NET-EXT-NW  $ext_nw/$ext_nw_prefix --name SUBNET-EXT-NW"
		getTimeStamp
                if ! neutron --os-tenant-name $admin_tenant --os-username $admin_uname --os-password $default_pwd subnet-create NET-EXT-NW $ext_nw/$ext_nw_prefix --name SUBNET-EXT-NW; then
                        handle_neutron_error
                        exit 1
                fi
                sleep $pause
}

deleteExtNW(){
                echo "Executing: neutron subnet-delete SUBNET-EXT-NW"
		getTimeStamp
                if ! neutron --os-tenant-name $admin_tenant --os-username $admin_uname --os-password $default_pwd subnet-delete SUBNET-EXT-NW; then
                        handle_neutron_error
                        exit 1
                fi
                sleep $pause

		echo "Executing: neutron net-delete NET-EXT-NW"
		getTimeStamp
                if ! neutron --os-tenant-name $admin_tenant --os-username $admin_uname --os-password $default_pwd net-delete NET-EXT-NW; then
                        handle_neutron_error
                        exit 1
                fi
                sleep $pause

}

listExtNW(){
        echo "Executing: neutron net-list"
        getTimeStamp
        if ! neutron --os-tenant-name $admin_tenant --os-username $admin_uname --os-password $default_pwd net-list; then
                handle_neutron_error
                exit 1
        fi
        echo "Executing: neutron subnet-list"
        getTimeStamp
        if ! neutron --os-tenant-name $admin_tenant --os-username $admin_uname --os-password $default_pwd subnet-list; then
                handle_neutron_error
                exit 1
        fi
        echo "Sleeping for $pause seconds..."
        sleep $pause
}

updateExtNW(){
	echo "Update Ext NW functionality is not yet complete.. skip for now. "
}
#listExtNw(){
#neutron net-list -- --router:external True
#}
