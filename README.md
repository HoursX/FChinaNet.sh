## FChinaNet.sh
用bash脚本来认证天翼校园吧~

[![GitHub license](https://img.shields.io/github/license/Anapopo/FChinaNet.sh.svg?style=flat-square)](https://github.com/Anapopo/FChinaNet.sh/blob/master/LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/Anapopo/FChinaNet.sh.svg?style=flat-square)](https://github.com/Anapopo/FChinaNet.sh/stargazers)
![AUR](https://img.shields.io/aur/version/fchinanet-sh.svg?style=flat-square)
![Github All Releases](https://img.shields.io/github/downloads/Anapopo/FChinaNet.sh/total.svg?style=flat-square)
## 使用方式

### 通用
使用 `git clone` 本项目  
将`verify.sh`通过scp放入路由器内，将路由器WAN口连接至校园网，确保WAN口打开DHCP，用于自动获取IP。  
有时verify.sh没有可执行权限，可通过执行 `chmod +x verify.sh` 赋予执行权限。  
最后通过执行`./verify.sh`或者`sh verify.sh`来进行认证操作。

### ArchLinux AUR
一行命令`yaourt fchinanet-sh`，安装位置位于 `/usr/bin/fnet`  
第一次执行前在 `/usr/bin/fnet` 内填入用户名密码  
以后需要登录时只需执行 `fnet`  
还可以添加为开机脚本哟  

## Tips

### 关于账户密码
如果不想每次认证手动输入账户密码，那么请手动更改脚本内的`AUTH`变量。  
举例：`AUTH="181xxxx2345:123456"`

### 测试用例
+ 斐讯K2 + Padavan 通过
+ 梅林 通过
