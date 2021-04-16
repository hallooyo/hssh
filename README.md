# ssh for mac 远程连接脚本!

 * Author: 韩振
 * Source: https://github.com/hallooyo/hssh 
 * Email: 278375858@qq.com
 * Latest Stable: 0.0.3


这是一个用于在mac上连接服务器的小工具，可以将服务器信息配置到文件中，使得连接更加方便

##使用帮助：

 * 可以在/etc/profile中可以使用如下命令进行配置别名：
 * alias s='sh $你的存储路径/hssh/bin/hssh.sh'
 * 通过source /etc/profile更新环境变量，使别名生i效
 * 此过程在conf/init.sh中已经实现，可以直接使用


##更新历史：

 - 2015-9-8  新增了一个scp，用于从服务器下载文件和目录
 - 2015-8-31 新建一个项目，ssh到远程服务器。
 - 2020-4-13 允许远程下载json形式的连接信息
 - 2021-3-16 丰富远程连接、上传、下载功能
