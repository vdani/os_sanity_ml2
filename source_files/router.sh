#!/bin/bash
source ./source_files/utility.sh
source ./source_files/handle_error.sh

# Create router
createRouter(){
#	local i=1
#	while [ $i -le $router_count ]
#	do
		i=$(echo "$1" | cut -d "-" -f 2)
		echo "Executing: neutron router-create router-$i"
		getTimeStamp
		if ! neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd router-create router-$i; then
			handle_neutron_error
			exit 1
		fi	
		echo "Sleeping for $pause seconds..."
		sleep $pause
#	(( i++ ))
#	done
#	echo "Sleeping for $pause seconds..."
#	sleep $pause
}


# List routers
listRouter(){	
	echo "Executing: neutron router-list"
	getTimeStamp
	if ! neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd router-list; then
		handle_neutron_error
		exit 1
	fi
#	read_count=$(neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd router-list | grep router | wc -l)
#	echo "Validating: Number of routers against those created..."
#		if [ $read_count -eq $router_count ]; then
#			echo "Read:$read_count, Created:$router_count, PASS" 
#		else 
#			echo "Read:$read_count, Created:$router_count, FAIL"
#		fi
	echo "Sleeping for $pause seconds..."
	sleep $pause
}



# Update router
#updateRouter(){
#	local i=1
#	listRouterID=$(neutron router-list | grep router | cut -d "|" -f 2)
 #  	for routerID in $listRouterID; do
  #    		echo "Executing: neutron router-update $routerID --name Router-VLAN-MOD-$i --segment_range $router_mod_range_start-`expr $router_mod_range_start + $router_range_size`"
#		getTimeStamp
   #  		if ! neutron --os-tenant-name $1 --os-username $1 --os-password $1 router-update $routerID --name Router-VLAN-MOD-$i --segment_range $router_mod_range_start-`expr $router_mod_range_start + $router_range_size`; then
#			handle_neutron_error
#			exit 1
#		fi
#		echo "Sleeping for $pause seconds..."
#		sleep $pause
 #    		(( i++ ))
 #	done
#	sleep $pause
#}



# Delete router
deleteRouter(){
	listRouterID=$(neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd router-list | grep -i router | cut -d "|" -f 2)
	for routerID in $listRouterID; do
		echo "Executing: neutron router-delete $routerID"
		getTimeStamp
		if ! neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd router-delete $routerID; then
			handle_neutron_error
			exit 1
		fi
		echo "Sleeping for $pause seconds..."
		sleep $pause
	done
}


addInterfaceToRouter(){

	listRouterID=$(neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd router-list | grep -i router | cut -d "|" -f 2)
	listSubnetID=$(neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd subnet-list | cut -d "|" -f 2 | grep [0-9])
	local i=1
        for routerID in $listRouterID; do
		local k=1
		local j=1	
		for subnetID in $listSubnetID; do
		#	if [ $k -lt $i ]; then
		#		(( k++ ))
		#		continue
		#	fi

		#	if [ $j -le $interfaces_per_router ]; then
				echo "Executing: neutron router-interface-add $routerID $subnetID"
				getTimeStamp
				if ! neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd router-interface-add $routerID $subnetID; then
					handle_neutron_error
                        		exit 1
                		fi
		#		(( j++ ))	
		#	else
		#		break
		#	fi
		done
		#i=`expr $i + $interfaces_per_router`
	done
}


removeInterfaceFromRouter(){

        listRouterID=$(neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd router-list | grep -i router | cut -d "|" -f 2)
        for routerID in $listRouterID; do
		listRouterPortID=$(neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd router-port-list $routerID | cut -d "|" -f 2 | grep [0-9])
		for routerPortID in $listRouterPortID; do	
			echo "Executing: neutron router-interface-delete $routerID  port=$routerPortID"
			getTimeStamp
                	if ! neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd router-interface-delete $routerID port=$routerPortID; then
                                handle_neutron_error
                                exit 1
                        fi
                done
        done    
}


setExtGwToRouter(){

	listRouterID=$(neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd router-list | grep -i router | cut -d "|" -f 2)
	ext_net_id=$(neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd net-list -- --router:external True | cut -d "|" -f 2 | grep [0-9])
	for routerID in $listRouterID; do
		echo "Executing: neutron router-gateway-set $routerID $ext_net_id"
		getTimeStamp
		if ! neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd router-gateway-set $routerID $ext_net_id; then
			handle_neutron_error
			exit 1
		fi
	done
}

clearExtGwFromRouter(){

	listRouterID=$(neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd router-list | grep -i router | cut -d "|" -f 2)
        ext_net_id=$(neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd net-list -- --router:external True | cut -d "|" -f 2 | grep [0-9])
        for routerID in $listRouterID; do
		echo "Executing: neutron router-gateway-clear $routerID"
		getTimeStamp
                if ! neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd router-gateway-clear $routerID; then
                        handle_neutron_error
                        exit 1
                fi
        done
}

associateFloatingIP(){
	listInstanceID=$(nova --os-tenant-name $1 --os-username $1 --os-password $default_pwd list  | cut -d "|" -f 2 | grep [0-9])
	extNetID=$(neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd net-list -- --router:external True | cut -d "|" -f 2 | grep [0-9])
	for instanceID in $listInstanceID; do
		listPortID=$(neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd port-list -c id -c fixed_ips -- --device_id $instanceID | cut -d "|" -f 2 | grep [0-9])
		for portID in $listPortID; do
			echo "Executing: neutron floatingip-create --port_id $portID $extNetID"
			getTimeStamp
			if ! neutron  --os-tenant-name $1 --os-username $1 --os-password $default_pwd floatingip-create --port_id $portID $extNetID; then
				 handle_neutron_error
                        	exit 1
                	fi
		done
        done
}

disassociateFloatingIP(){
	listFloatingIPID=$(neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd floatingip-list  | cut -d "|" -f 2 | grep [0-9])
	for floatingIPID in $listFloatingIPID; do
		echo "Executing: neutron floatingip-disassociate $floatingIPID"
		getTimeStamp
		if ! neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd floatingip-disassociate $floatingIPID; then
			handle_neutron_error
                        exit 1
                fi
        done
}

deleteFloatingIP(){
	listFloatingIPID=$(neutron --os-tenant-name $1 --os-username $1 --os-password $default_pwd floatingip-list  | cut -d "|" -f 2 | grep [0-9])
	for floatingIPID in $listFloatingIPID; do
		echo "Executing: neutron floatingip-delete $floatingIPID"
		getTimeStamp
		if ! neutron  --os-tenant-name $1 --os-username $1 --os-password $default_pwd floatingip-delete $floatingIPID; then
			handle_neutron_error
                        exit 1
                fi
        done
}
