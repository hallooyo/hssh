#!/bin/bash

pathfile=$(cd `dirname $0`;pwd)
temp_file=$pathfile/../conf/iplist

sh $pathfile/../conf/init.sh

dog=`echo $1 | grep '^\.'`

#非法输入检查，不能以点开头
if [ -n "$dog" ] ; then
    echo "您的输入中有个点作为通配符，不能使用，请输入一个准确的IP！"
	exit 1;
fi

printip() {
#拿到与输入参数相同的服务器信息
resule_val=`awk -v v=$1 '$1 == v' $temp_file`
if [  -n "$resule_val" ];then
	echo "获取参数成功！"
else
	echo "您输入的入参无效！"
	exit 2;
fi

ip=`echo $resule_val | awk -F ' ' '{print $2}' `
username=`echo $resule_val | awk -F ' ' '{print $3}'`
password=`echo $resule_val | awk -F ' ' '{print $4}'`


#仅判断ip是否正确即可
if [  -n $ip ];then
   echo "显示链接参数：" $ip $username
   echo "正在为您启动连接！"
   $pathfile/../sbin/ssh.sh $ip $username $password
else
   echo $ip"输入不正确，列表中没有这个ip！"
fi

}

case $1 in
    `echo $1 | grep '^\qa'`)
        echo "为您查询"$1" 环境列表"
        env=`echo $1 | tr 'a-z' 'A-Z'`
	awk -v v=$env '$5 == v {print $5"---------"$2"\r"}' $temp_file
	echo "查询完毕！"
	;;
    `echo $1 | grep '^\dev'`)
        echo "为您查询"$1" 环境列表"
        env=`echo $1 | tr 'a-z' 'A-Z'`
        awk -v v=$env '$5 == v {print $5"---------"$2"\r"}' $temp_file
        echo "查询完毕！"
        ;;
    [a-z][1-9]*)
        echo "为您查询ip 信息"
        printip $1
	echo "查询完毕！"
        ;;
    l)
	cat $temp_file
	echo "您可以输入第五列中的环境标示，精确查找各环境的服务器信息" 
	echo "查询完毕！"
        ;;
    v)
	vi $temp_file
	;;
    *)
        echo "无法识别的参数，请重新输入!"
        ;;
esac
