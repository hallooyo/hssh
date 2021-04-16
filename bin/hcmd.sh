#!/bin/bash -x

if [ $# -ne 2 ]; then
    echo $"Usage: $0 cmd"
    exit 1
fi

cmd=$1
iplist=$2


# 批量执行命令
for ip in $iplist
do
	resule_json=$(curl http://kit.jd.com/dtu/getPassWordByIp\?ip\=$ip)

	result=$(echo $resule_json | grep "susername")

	if [ -n "$result" ];then
	    ip=$(echo $resule_json| jq -c '.data' | jq -cr '.sip')
	    username=$(echo $resule_json| jq -c '.data' | jq -cr '.susername')
	    password=$(echo $resule_json | jq -c '.data' | jq -cr '.sPassword')
	    port=$(echo $resule_json | jq -c '.data' | jq -cr '.sport')
	else
	    echo "当前 ip:${ip} 无法从本地或远程加载"
	    exit 2;
	fi

    /usr/bin/expect ../sbin/cmd.exp $ip $password "$cmd"
done
