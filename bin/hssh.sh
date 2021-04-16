#!/bin/sh -x


# 获取第一个入参
dog=`echo $1 | grep '^\.'`
# 非法输入检查，不能以点开头
if [ -n "$dog" ] ; then
    echo "您的输入中有个点作为通配符，不能使用，请输入一个准确的IP！"
  exit 1;
fi

# 当前路径
pathfile=$(cd `dirname $0`;pwd)

# 添加快捷命令到环境变量中
sh $pathfile/../conf/init.sh

# 初始化获取参数的脚本
configPath=$pathfile/../conf/config.json

# 初始化信息
ip=$(cat $configPath | jq  -cr '.ip')

port=$(cat $configPath  | jq  -cr '.port')

username=$(cat $configPath  | jq  -cr '.username')

password=$(cat $configPath  | jq  -cr '.password')

domain=$(cat $configPath  | jq  -cr '.domain')

# 默认的配置列表
temp_file=$pathfile/../conf/iplist

problem(){
        echo "当您发现这个提示,说明您需要阅读帮助信息"

        echo "-------------------------------------------------------------"

        echo "For example(print config list)
              s l "

        echo "For example(edit config list)
              s v "

        echo "For example(connect to remote server)
              s t11.51.195.29"
      
        echo "For example(download remote server file)
              s d11.51.195.29 /etc/yum.repos.d/CentOS-Base.repo"

        echo "For example(download remote server file)
              s u11.51.195.29 /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak"

        echo "-------------------------------------------------------------"
}


# 获取服务器的连接信息 首先通过本地文件获取 再通过Domain获取
getServerInfo(){
  # 获取 IP 信息 :1是说从第二个开始取内容，忽略t或d这样的功能参数
  ip=${1:1}
  resule_val=`awk -v v=$1 '$1 == v' $temp_file`
  if [  -n "$resule_val" ];then
    echo "获取参数成功！"
    ip=`echo $resule_val | awk -F ' ' '{print $2}' `
    username=`echo $resule_val | awk -F ' ' '{print $3}'`
    password=`echo $resule_val | awk -F ' ' '{print $4}'`
    port=`echo $resule_val | awk -F ' ' '{print $5}'`
  else
    resule_json=$(curl $domain$ip)
    echo $resule_json
    result=$(echo $resule_json | grep "susername")
    if [ -n "$result" ];then
        ip=$(echo $resule_json| jq -c '.data' | jq -cr '.sip')
        username=$(echo $resule_json| jq -c '.data' | jq -cr '.susername')
        password=$(echo $resule_json | jq -c '.data' | jq -cr '.spassword')
        port=$(echo $resule_json | jq -c '.data' | jq -cr '.sport')
      else
        echo "当前 ip:${ip} 无法从本地或远程加载"
        exit 2;
    fi
  fi
}

connectIP() {

  # 获取服务器的连接信息
  getServerInfo $1

  # 仅判断ip是否正确即可
  if [  -n $ip ];then
     echo "显示链接参数：" $ip $username $password $port
     echo "正在为您启动连接!"
     $pathfile/../sbin/ssh.sh $ip $username $password $port
  else
     echo "输入错误,示例:s t11.51.195.29"
  fi

}

download(){

  remoteFilePath=`echo $2 | grep '^\/'`

  if [ ! -n "$remoteFilePath" ] ; then
      echo "请输入要下载目录或文件的绝对路径时应以/开头!"
      exit 2;
  fi

  # 获取服务器的连接信息
  getServerInfo $1

  #仅判断ip是否正确即可
  if [  -n $ip -a -n $remoteFilePath ];then
     echo "显示链接参数：" $ip $username
     echo "正在为您下载"$remoteFilePath
     $pathfile/../sbin/dscp.sh $ip $remoteFilePath $username $password
  else
     echo "输入错误,示例:s d11.51.195.29 /home/admin/auto-add-tomcat.tar.gz"
  fi
}

upload(){

  localFilePath=`echo $2 | grep '^\/'`

  if [ ! -n "$localFilePath" ] ; then
      echo "请输入本地文件夹或文件路径,应以/开头!"
      exit 2;
  fi

  remoteFilePath=`echo $3 | grep '^\/'`

  if [ ! -n "$remoteFilePath" ] ; then
      echo "请输入远程文件夹或文件路径,应以/开头!"
      exit 2;
  fi

  # 获取服务器的连接信息
  getServerInfo $1

  #仅判断ip是否正确即可
  if [  -n $ip -a -n $localFilePath -a -n $remoteFilePath ];then
     echo "显示链接参数：" $ip $username
     echo "正在为您上传"$localFilePath"到"$remoteFilePath
     $pathfile/../sbin/uscp.sh $ip $username $password $localFilePath $remoteFilePath
  else
     echo "输入错误,示例:s u11.51.195.29 auto-add-tomcat.tar.gz /home/admin/auto-add-tomcat.tar.gz"
  fi
}

if [ $# -eq 1 ];then
  case $1 in
      [a-z][1-9]*)
          mark=${1:0:1}
          echo ss$mark
          if [ "t" != "$mark" ] ; then
              echo "指令解析失败"
              problem
              exit 2;
          fi
          echo "正在连接服务器......"
          connectIP $1
          echo "断开连接！"
          ;;
      l)
          cat $temp_file
          echo "正在查询......"
          echo "查询完毕!"
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
          mark=${1:0:1}
          if [ "d" != "$mark" ] ; then
              echo "指令解析失败"
              problem
              exit 2;
          fi
          echo "正在准备下载连接......"
          download $1 $2
          echo "断开连接!"
          ;;
      *)
          problem
          ;;
  esac
fi

if [ $# -eq 3 ];then
  case $1 in
      [a-z][1-9]*)
          mark=${1:0:1}
          if [ "u" != "$mark" ] ; then
              echo "指令解析失败"
              problem
              exit 2;
          fi
          echo "正在准备上传......"
          upload $1 $2 $3
          echo "断开连接!"
          ;;
      *)
          problem
          ;;
  esac
fi
