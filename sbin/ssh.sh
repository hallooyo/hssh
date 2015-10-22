#!/usr/bin/expect -f
 set ip [lindex $argv 0]
 set username [lindex $argv 1]
 set password [lindex $argv 2]
 set timeout 30

 spawn ssh -l $username $ip
 expect {
 "*yes/no" { send "yes\r"; exp_continue}
 "*password:" { send "$password\r" }
 }
 interact
