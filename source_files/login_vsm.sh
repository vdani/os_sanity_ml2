#!/usr/bin/expect

set vsm_login "admin"
set vsm_ip "10.197.129.83"
set vsm_pwd "Sfish123"
set prompt "#"
spawn ssh -o StrictHostKeyChecking=no $vsm_login@$vsm_ip
expect "assword:"
send "$vsm_pwd\r"
expect "$prompt"

match_max 50000
set expect_out(buffer) {}
send "show run network segment manager switch | no-more\r"
expect "$prompt"
exec echo $expect_out(buffer) >> ./outputs/show_run_nsm_switch 

set expect_out(buffer) {}
send "show nsm network segment | no-more\r"
expect "$prompt"
exec echo $expect_out(buffer) >> ./outputs/show_nsm_nw_seg

set expect_out(buffer) {}
send "show nsm network vethernet | no-more\r"
expect "$prompt"
exec echo $expect_out(buffer) >> ./outputs/show_nsm_nw_veth

set expect_out(buffer) {}
send "show nsm ip pool template | no-more\r"
expect "$prompt"
exec echo $expect_out(buffer) >> ./outputs/show_nsm_ip_pool

send "\r"

