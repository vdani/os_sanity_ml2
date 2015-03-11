#!/bin/bash

source ./script_input

listTenant=$(keystone --os-tenant-name $admin_tenant --os-username $admin_uname --os-password $admin_pwd tenant-list | grep [0-9] | grep -v "admin \| services" | cut -d "|" -f 3)

for tenant in $listTenant; do
	./single_tenant.sh $tenant &
done 

