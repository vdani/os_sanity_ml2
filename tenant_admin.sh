#!/bin/bash
source ./script_input
source ./source_files/network.sh
source ./source_files/port.sh
source ./source_files/instance.sh
source ./source_files/router.sh
source ./source_files/tenant.sh
source ./source_files/utility.sh

echo " =========================================================================="
echo "                       TENANT ADMIN OPERATIONS CATALOG                      "
echo " =========================================================================="
echo "   1. Create networks"
echo "   2. Create ports"
echo "   3. Create instance (Launch VM)"
echo "   4. Create router"
echo "   5. Add interface to router"
echo "   6. Set external gateway to router"
echo "   7. Associate floating IP to router interafce"
echo " --------------------------------------------------------------------------"
echo "   8. List networks"
echo "   9. List ports"
echo "  10. List instances"
echo "  11. List routers"
echo " --------------------------------------------------------------------------"
echo "  12. Update networks"
echo " --------------------------------------------------------------------------"
echo "  13. Disassociate floating IP from router interafce"
echo "  14. Clear external gateway from router"
echo "  15. Remove interface from router"
echo "  16. Delete router"
echo "  17. Delete floating IPs"
echo "  18. Delete ports"
echo "  19. Delete instances"
echo "  20. Delete networks"
echo " =========================================================================="
echo "  21. CLEANUP TENANT SETUP"
echo " =========================================================================="
echo " "

read -p "Input comma separeted options from above to be executed: " user_input
refined_input=$(echo $user_input | tr "," "\n")

echo "#!/bin/bash" > single_tenant.sh
echo "source ./script_input" >> single_tenant.sh
echo "source ./source_files/network.sh" >> single_tenant.sh
echo "source ./source_files/port.sh" >> single_tenant.sh
echo "source ./source_files/instance.sh" >> single_tenant.sh
echo "source ./source_files/router.sh" >> single_tenant.sh
echo "source ./source_files/tenant.sh" >> single_tenant.sh
echo " " >> single_tenant.sh


chmod +x single_tenant.sh

for input in $refined_input;do
        case $input in
		1 ) echo "createNW \$1" >> single_tenant.sh;;
		2 ) echo "createPort \$1" >> single_tenant.sh;;
		3 ) echo "launchVM \$1" >> single_tenant.sh;;
		4 ) echo "createRouter \$1" >> single_tenant.sh;;
		5 ) echo "addInterfaceToRouter \$1" >> single_tenant.sh;;
		6 ) echo "setExtGwToRouter \$1" >> single_tenant.sh;;
		7 ) echo "associateFloatingIP \$1" >> single_tenant.sh;;
		8 ) echo "listNW \$1" >> single_tenant.sh;;
		9 ) echo "listPort \$1" >> single_tenant.sh;;
		10 ) echo "listVM \$1" >> single_tenant.sh;;
		11 ) echo "listRouter \$1" >> single_tenant.sh;;
		12 ) echo "updateNW \$1" >> single_tenant.sh;;
		13 ) echo "disassociateFloatingIP \$1" >> single_tenant.sh;;
		14 ) echo "clearExtGwFromRouter \$1" >> single_tenant.sh;;
		15 ) echo "removeInterfaceFromRouter \$1" >> single_tenant.sh;;
		16 ) echo "deleteRouter \$1" >> single_tenant.sh;;
		17 ) echo "deleteFloatingIP \$1" >> single_tenant.sh;;
		18 ) echo "deletePort \$1" >> single_tenant.sh;;
		19 ) echo "deleteVM \$1" >> single_tenant.sh;;
		20 ) echo "deleteNW \$1" >> single_tenant.sh;;
		21 ) echo "disassociateFloatingIP \$1" >> single_tenant.sh;
                     echo "clearExtGwFromRouter \$1" >> single_tenant.sh;
                     echo "removeInterfaceFromRouter \$1" >> single_tenant.sh;
                     echo "deleteRouter \$1" >> single_tenant.sh;
                     echo "deleteFloatingIP \$1" >> single_tenant.sh;
                     echo "deletePort \$1" >> single_tenant.sh;
                     echo "deleteVM \$1" >> single_tenant.sh;
                     echo "deleteNW \$1" >> single_tenant.sh;;
		 * ) echo "Please enter correct input.";;
	esac
done

echo " " > execution_summary_tenant
echo " ============================" >> execution_summary_tenant
echo "   TENANT EXECUTION SUMMARY  " >> execution_summary_tenant
echo " ============================" >> execution_summary_tenant
echo " " >> execution_summary_tenant

echo " "
echo " "
echo "--------------------------------------------------------- "
echo "All inputs are successful. Please read below to continue:"
echo "--------------------------------------------------------- "
echo " "
echo "Script will now run in multi-tenant mode."
echo "Please hit [Enter] to continue.."
echo " "
echo "If you want to run in single-tenant mode, hit [Ctrl+C]"
echo "and then execute ./single_tenant.sh <tenant-name>"
echo " "
echo "--------------------------------------------------------- "
echo " "
pause 'Press [Enter] key to continue...'
./multi_tenant.sh

