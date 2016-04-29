#!/usr/bin/expect -f
set ip [lindex $argv 0]
set filepath [lindex $argv 1]
set username [lindex $argv 2]
set password [lindex $argv 3]
set timeout 10    
set filename [lindex $argv 4]
spawn scp -r $username@$ip:$filepath .
 expect {
 "*yes/no" { send "yes\r"; exp_continue}
 "*password:" { send "$password\r" }
 }
 interact
