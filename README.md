## FChinaNet.sh
用bash脚本来认证天翼校园吧~

## 使用方式
将`verify.sh`通过scp放入路由器内，将路由器WAN口连接至校园网，确保WAN口打开DHCP，用于自动获取IP。  
有时verify.sh没有可执行权限，可通过执行 `chmod +x verify.sh` 赋予执行权限。  
最后通过执行`./verify.sh`或者`sh verify.sh`来进行认证操作。

### 关于账户密码
如果不想每次认证手动输入账户密码，那么请手动更改脚本内的`AUTH`变量。  
举例：AUTH="用户名:密码"

## 测试用例
+ 斐讯K2 + Padavan 通过
+ 梅林 通过
