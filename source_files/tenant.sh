#!/bin/bash
source ./source_files/utility.sh
source ./source_files/handle_error.sh

createTenants(){
local i=1
	while [ $i -le $1 ]
	do
		echo "Executing: keystone --name tenant-$i --description Tenant-$i"
		getTimeStamp
		if ! keystone --os-tenant-name $admin_tenant --os-username $admin_uname --os-password $default_pwd tenant-create --name tenant-$i --description Tenant-$i; then
			handle_keystone_error
			exit 1
		fi
		
  		echo "Executing: keystone user-create --name=tenant-$i --pass=$default_pwd --tenant=tenant-$i"
        	getTimeStamp
        	if ! keystone --os-tenant-name $admin_tenant --os-username $admin_uname --os-password $default_pwd user-create --name=tenant-$i --pass=$default_pwd --tenant=tenant-$i ; then
                	handle_keystone_error
                	exit 1
        	fi

		sleep $pause
		(( i++ ))
	done
}


deleteTenants(){
                listUserID=$(keystone --os-tenant-name $admin_tenant --os-username $admin_uname --os-password $default_pwd user-list | grep tenant | cut -d "|" -f 2)
                for userID in $listUserID; do
                        echo "Executing: keystone user-delete $userID"
                        getTimeStamp
                        if ! keystone --os-tenant-name $admin_tenant --os-username $admin_uname --os-password $default_pwd user-delete $userID; then
                                handle_keystone_error
                                exit 1
                        fi
		done

		listTenantID=$(keystone --os-tenant-name $admin_tenant --os-username $admin_uname --os-password $default_pwd tenant-list | grep tenant | cut -d "|" -f 2)
                for tenantID in $listTenantID; do
                        echo "Executing: keystone tenant-delete $tenantID"
                        getTimeStamp
                        if ! keystone --os-tenant-name $admin_tenant --os-username $admin_uname --os-password $default_pwd tenant-delete $tenantID; then
                                handle_keystone_error
                                exit 1
                        fi

                        sleep $pause
                done
}

listTenants(){
                        echo "Executing: keystone tenant-list"
                        getTimeStamp
                        if ! keystone --os-tenant-name $admin_tenant --os-username $admin_uname --os-password $default_pwd tenant-list; then
                                handle_keystone_error
                                exit 1
                        fi

                        sleep $pause
}

listUsers(){
                        echo "Executing: keystone user-list"
                        getTimeStamp
                        if ! keystone --os-tenant-name $admin_tenant --os-username $admin_uname --os-password $default_pwd user-list; then
                                handle_keystone_error
                                exit 1
                        fi

                        sleep $pause
}

