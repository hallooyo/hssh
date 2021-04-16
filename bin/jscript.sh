if [[ $1 && $2 ]];then
  echo "开始执行脚本..."
else
  echo "没有识别到账密信息"
  exit 0
fi
echo "开始安装git"
yum install -y git
#echo "远程复制maven"
#scp -r root@11.51.195.68:/export/servers/apache-maven-3.6.3 /export/servers/apache-maven-3.6.3
echo "----------------------------------------------------------------------------------------------------------------"
echo "下载jar包，期间需要您输入coding账密信息(请勿携带@jd.com后缀),示例lishuai228回车"
cd /export/servers/&&git clone http://$1:$2@coding.jd.com/selena/machine.git
if [ -e "/export/servers/machine/" ];then
  echo "文件下载完成"
else
  echo "文件下载失败"
  exit 0
fi
echo "----------------------------------------------------------------------------------------------------------------"
echo "移动目录"
mv /export/servers/machine/apache-maven-3.6.3 /export/servers/
if [ -e "/export/autoSVN/amp/" ];then
  echo "/export/autoSVN/amp/目录已经存在无需创建"
else
  mkdir -p /export/autoSVN/amp/
fi
mv /export/servers/machine/slave.jar /export/autoSVN/amp/
rm -rf machine/
echo "----------------------------------------------------------------------------------------------------------------"
echo "添加环境变量"
#echo "export MAVEN_HOME=/export/servers/apache-maven-3.6.3">>/etc/profile
pathinfo=`cat /etc/profile|grep "export PATH="`
result=`echo $pathinfo | grep "apache-maven"`
if [[ $result != ""  ]];then
  echo "环境变量中已经存在MAVEN数据"
else
  echo "原PTAH变量 $pathinfo"
  pathinfo1=$pathinfo:/export/servers/apache-maven-3.6.3/bin
  echo "新PATH变量 $pathinfo1"
  sed -i "s|$pathinfo|$pathinfo1|g" /etc/profile
  source /etc/profile
fi
echo "----------------------------------------------------------------------------------------------------------------"
echo "启动进程"
IP=`hostname -I`
info=`curl -s http://schedule.ms.jd.com/dtu/jenkins/jnlp/secret?ip=$IP`
#逻辑判断
echo `ps -ef | grep $IP`
#结束之前的进程
PROCESS_IDS=`ps -ef | grep $IP | awk '{print $2}'`
echo PROCESS IDS is $PROCESS_IDS
for PROCESS_ID in $PROCESS_IDS; do
    kill -9 $PROCESS_ID
    echo [Info]"Kill Process ID = $PROCESS_ID"
done
echo "执行命令 nohup java $info &"
nohup java $info &

# 删除并追加hosts
result=`cat /etc/hosts | grep -v jsf`
echo "$result" > /etc/hosts
echo "11.50.59.166 i.jsf.jd.com" >> /etc/hosts
echo "11.50.59.188 i.jsf.jd.com" >> /etc/hosts

rm $0
