#!/bin/bash
source ./source_files/utility.sh

handle_neutron_error(){
	ts=$(date | cut -c 12-16)
	cat /var/log/neutron/server.log | grep $ts | grep -i "error \| trace \| fail \| info" >> ./logs/clean/error.log_$timestamp
        cp /var/log/neutron/server.log ./logs/full/server.log_$timestamp
}

handle_keystone_error(){
	ts=$(date | cut -c 12-16)
	cat /var/log/neutron/server.log | grep $ts | grep -i "error \| trace \| fail \| info" >> ./logs/clean/error.log_$timestamp
        cp /var/log/neutron/server.log ./logs/full/server.log_$timestamp
}

handle_nova_error(){
	ts=$(date | cut -c 12-16)
	cat /var/log/neutron/server.log | grep $ts | grep -i "error \| trace \| fail \| info" >> ./logs/clean/error.log_$timestamp
        cp /var/log/neutron/server.log ./logs/full/server.log_$timestamp
}

#handle_generic_error(){}
