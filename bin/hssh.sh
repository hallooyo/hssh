#!/bin/bash -e

pathfile=$(cd `dirname $0`;pwd)
temp_file=$pathfile/../conf/iplist

sh $pathfile/../conf/init.sh

dog=`echo $1 | grep '^\.'`

#非法输入检查，不能以点开头
if [ -n "$dog" ] ; then
    echo "您的输入中有个点作为通配符，不能使用，请输入一个准确的IP！"
	exit 1;
fi

problem(){
        echo "不知道的你要干嘛！你可以尝试一下操作："
        echo "-------------------------------------------------------------"
        echo "Syntax format : [command] [desAddr] [remoteFile]"
        echo "For example(connect to remote server)：
              s d1 "
        echo "For example(print desAddr list)：
              s l "
        echo "For example(edit desAddr list)：
              s v "
        echo "For example(download remote server file)：
              s d1 /etc/yum.repos.d/CentOS-Base.repo"
        echo "-------------------------------------------------------------"
}

connectIP() {
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


download(){
filepath=`echo $2 | grep '^\/'`

if [ ! -n "$filepath" ] ; then
    echo "请输入要下载目录或文件的绝对路径时应以/开头！"
    exit 2;
fi

#拿到与输入参数相同的服务器信息
resule_val=`awk -v v=$1 '$1 == v' $temp_file`
if [  -n "$resule_val" ];then
  echo "获取参数成功！"
else
  echo "获取参数失败！"
  exit 2;
fi

ip=`echo $resule_val | awk -F ' ' '{print $2}' `
username=`echo $resule_val | awk -F ' ' '{print $3}'`
password=`echo $resule_val | awk -F ' ' '{print $4}'`


#仅判断ip是否正确即可
if [  -n $ip ];then
   echo "显示链接参数：" $ip $username
   echo "正在为您下载！"
   $pathfile/../sbin/dscp.sh $ip $2 $username $password
else
   echo $ip"输入不正确，列表中没有这个ip！"
fi
}

if [ $# -eq 1 ];then
case $1 in
    [a-z][1-9]*)
        echo "正在连接服务器......"
        connectIP $1
        echo "断开连接！"
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
        problem
        ;;
esac
fi

if [ $# -eq 2 ];then
case $1 in
    [a-z][1-9]*)
        echo "正在准备下载连接......"
        download $1 $2
        echo "断开连接！"
        ;;
    *)
        problem
        ;;
esac
fi

