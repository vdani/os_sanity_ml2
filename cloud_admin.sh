#!/bin/bash
source ./script_input
source ./source_files/network.sh
source ./source_files/port.sh
source ./source_files/instance.sh
source ./source_files/router.sh
source ./source_files/tenant.sh

echo " =========================================================================="
echo "                       CLOUD ADMIN OPERATIONS CATALOG                      "
echo " =========================================================================="
echo "   1. Create Tenants"
echo "   2. List Tenants"
echo "   3. List Users"
echo "   4. Delete Tenants"
echo " --------------------------------------------------------------------------"
echo "   5. Create External Network"
echo "   6. List External Network"
echo "   7. Update External Network"
echo "   8. Delete External Network"
echo " =========================================================================="
echo " "

read -p "Input comma separeted options from above to be executed: " user_input
refined_input=$(echo $user_input | tr "," "\n")

for input in $refined_input;do
	case $input in
		1 ) createTenants $tenant_count;;
		2 ) listTenants;; 
		3 ) listUsers;;
		4 ) deleteTenants;;
		5 ) createExtNW;;
		6 ) listExtNW;;
		7 ) updateExtNW;;
		8 ) deleteExtNW;;
		* ) echo "Please enter correct input.";;
	esac
done
