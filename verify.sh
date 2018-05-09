#!/bin/sh

# 请按照 USER:PASS 的格式填写掌上大学账户和密码 
AUTH=":"

if [ "x$AUTH" == "x:" ] ; then
  read -p "Account: " ACCOUNT
  read -p "Password: " PASSWD
  AUTH="$ACCOUNT:$PASSWD"
fi

ACCOUNT=${AUTH:0:11}

echo "Account:" $ACCOUNT
UA="Mozilla/5.0 (iPhone 84; CPU iPhone OS 10_3_3 like Mac OS X) AppleWebKit/603.3.8 (KHTML, like Gecko) Version/10.0 MQQBrowser/7.8.0 Mobile/14G60 Safari/8536.25 MttCustomUA/2 QBWebViewType/1 WKType/1"

# 获取USER_ID / SERVER_DID
USER_INFO=$(curl -sSk "https://www.loocha.com.cn:8443/login?1=Android_college_100.100.100/" \
  --user $AUTH \
  --user-agent "$UA")

USER_ID=$(echo -n $USER_INFO | grep -Eo '\"id\":\"[0-9]{7}\"' | awk -F: '{print $2}' | sed 's/"//g')
DID=$(echo -n $USER_INFO | grep -Eo '\"did\":\"[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}#0#0#.*\",' | awk -F: '{print $2}' | sed 's/[,"]//g') 
SERVER_DID=$(echo -n $DID | awk -F# '{print $1}')
# MODEL=$(echo -n $DID | awk -F# '{print $4}')
MODEL="default"
# echo "USER_INFO:" $USER_INFO
# echo "USER_ID:" $USER_ID
# echo "SERVER_DID:" $SERVER_DID
# echo "MODEL:" $MODEL

# 获取随机密码CODE
TOKEN="server_did=${SERVER_DID}&time=`date +%s000`&type=1"
SIGN=$(echo -n "mobile=${ACCOUNT}&model=${MODEL}&${TOKEN}" | md5sum | cut -d ' ' -f1 | tr a-z A-Z)
# echo "TOKEN:" $TOKEN
# echo "SIGN:" $SIGN
CODE=$(curl -sSk "https://wifi.loocha.cn/${USER_ID}/wifi/telecom/pwd?1=Android_college_100.100.100&${TOKEN}&sign=${SIGN}&mm=${MODEL}" \
  --user $AUTH \
  --user-agent "$UA" \
  | grep -Eo '\"password\":\"[0-9]{6}\"' | awk -F: '{print $2}' | sed 's/"//g')

echo "CODE:" $CODE

# 获取 WAN_IP 和 BRAS_IP
LOCATION=$(curl -sSkI http://test.f-young.cn | grep -E 'Location')
WAN_IP=$(echo $LOCATION | awk -F '[:?&]' '{print $4}' | awk -F= '{print $2}')
BRAS_IP=$(echo $LOCATION | awk -F '[:?&]' '{print $5}'| awk -F= '{print $2}')

echo "WAN_IP:" $WAN_IP
echo "BRAS_IP:" $BRAS_IP

# 获取 QRCODE
QRCODE=$(curl -sSk "https://wifi.loocha.cn/0/wifi/qrcode?1=Android_college_100.100.100&brasip=${BRAS_IP}&ulanip=${WAN_IP}&wlanip=${WAN_IP}&mm=default" \
  | grep -Eo 'HIWF://[a-z0-9]{32}')

echo "QRCODE:" $QRCODE

# 开始登录
TOKEN2="server_did=${SERVER_DID}&time=`date +%s000`&type=1"
# echo "TOKEN2:" $TOKEN2
SIGN2=$(echo -n "mobile=${ACCOUNT}&model=${MODEL}&${TOKEN2}" | md5sum | cut -d ' ' -f1 | tr a-z A-Z)
# echo "SIGN2:" $SIGN2
PARAM="1=Android_college_100.100.100&qrcode=${QRCODE}&code=${CODE}&mm=${MODEL}&${TOKEN2}&sign=${SIGN2}"
# echo "PARAM:" $PARAM

# 无法获取WAN_IP，退出
if [ "x$WAN_IP" == "x" ] ; then
    exit
fi

curl -kX POST \
     --user $AUTH \
     --user-agent "$UA" \
     "https://wifi.loocha.cn/${USER_ID}/wifi/telecom/auto/login?${PARAM}"
