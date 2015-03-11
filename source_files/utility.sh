#!/bin/bash

getTimeStamp(){
	timestamp_date=$(date +%d%m%y)
	timestamp_time=$(date +%H%M%S)
	timestamp=$timestamp_date"_"$timestamp_time
}

function pause(){
   read -p "$*"
}
