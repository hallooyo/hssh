# ssh for mac 远程连接工具!

 * Author: 韩振
 * Source: https://github.com/hallooyo/hssh 
 * Email: 278375858@qq.com
 * Latest Stable: 0.0.2


这是一个用于在mac上连接服务器的小工具，可以将服务器信息配置到文件中，使得连接更加方便

##使用帮助：

 * 可以在/etc/profile中可以使用如下命令进行配置别名：
 * alias s='sh $你的存储路径/hssh/bin/hssh.sh'
 * 通过source /etc/profile更新环境变量，使别名生效


##更新历史：

 - 2015-9-8  新增了一个scp，用于从服务器下载文件和目录
 - 2015-8-31 新建一个项目，ssh到远程服务器。
 - 2020-4-13 允许远程下载json形式的连接信息


##版权及致谢：

 再次对忠实用户以及为此脚本提供帮助的运维同学表示感谢！

 本程序完全免费，并基于 LGPL 协议开源。
