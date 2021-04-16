#!/usr/bin/expect -f
set ip [lindex $argv 0]
set username [lindex $argv 1]
set password [lindex $argv 2]
set sourcepath [lindex $argv 3]
set filepath [lindex $argv 4]
set timeout 10    
spawn scp -r $sourcepath $username@$ip:$filepath
 expect {
 "*yes/no" { send "yes\r"; exp_continue}
 "*password:" { send "$password\r" }
 }
 interact
