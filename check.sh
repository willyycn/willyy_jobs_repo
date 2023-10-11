#!/bin/bash
shell_version="1.4.1";
UA_Browser="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36";
UA_Dalvik="Dalvik/2.1.0 (Linux; U; Android 9; ALP-AL00 Build/HUAWEIALP-AL00)";
DisneyAuth="grant_type=urn%3Aietf%3Aparams%3Aoauth%3Agrant-type%3Atoken-exchange&latitude=0&longitude=0&platform=browser&subject_token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJiNDAzMjU0NS0yYmE2LTRiZGMtOGFlOS04ZWI3YTY2NzBjMTIiLCJhdWQiOiJ1cm46YmFtdGVjaDpzZXJ2aWNlOnRva2VuIiwibmJmIjoxNjIyNjM3OTE2LCJpc3MiOiJ1cm46YmFtdGVjaDpzZXJ2aWNlOmRldmljZSIsImV4cCI6MjQ4NjYzNzkxNiwiaWF0IjoxNjIyNjM3OTE2LCJqdGkiOiI0ZDUzMTIxMS0zMDJmLTQyNDctOWQ0ZC1lNDQ3MTFmMzNlZjkifQ.g-QUcXNzMJ8DwC9JqZbbkYUSKkB1p4JGW77OON5IwNUcTGTNRLyVIiR8mO6HFyShovsR38HRQGVa51b15iAmXg&subject_token_type=urn%3Abamtech%3Aparams%3Aoauth%3Atoken-type%3Adevice"
DisneyHeader="authorization: Bearer ZGlzbmV5JmJyb3dzZXImMS4wLjA.Cu56AgSfBTDag5NiRA81oLHkDZfu5L3CKadnefEAY84"
Font_Black="\033[30m";
Font_Red="\033[31m";
Font_Green="\033[32m";
Font_Yellow="\033[33m";
Font_Blue="\033[34m";
Font_Purple="\033[35m";
Font_SkyBlue="\033[36m";
Font_White="\033[37m";
Font_Suffix="\033[0m";
LOG_FILE="check.log";

clear;
echo -e "流媒体解锁测试" && echo -e "流媒体解锁测试" > ${LOG_FILE};
echo -e " ** 系统时间: $(date)" && echo -e " ** 系统时间: $(date)" >> ${LOG_FILE};

export LANG="en_US";
export LANGUAGE="en_US";

function PasteBin_Upload() {
    local uploadresult="$(curl -fsL -X POST \
        --url https://paste.ubuntu.com \
        --output /dev/null \
        --write-out "%{url_effective}\n" \
        --data-urlencode "content@${PASTEBIN_CONTENT:-/dev/stdin}" \
        --data "poster=${PASTEBIN_POSTER:-MediaUnlock_Test_By_CoiaPrant}" \
        --data "expiration=${PASTEBIN_EXPIRATION:-}" \
    --data "syntax=${PASTEBIN_SYNTAX:-text}")"
    if [ "$?" = "0" ]; then
        echo -e "${Font_Green}已生成报告 ${uploadresult} ${Font_Suffix}";
    else
        echo -e "${Font_Red}生成报告失败 ${Font_Suffix}";
    fi
}

function MediaUnlockTest_Netflix() {
    echo -n -e " Netflix:\t\t\t\t->\c";
    local result=`curl -${1} --user-agent "${UA_Browser}" -sSL "https://www.netflix.com/" 2>&1`;
    if [ "$result" == "Not Available" ];then
        echo -n -e "\r Netflix:\t\t\t\t${Font_Red}Unsupport${Font_Suffix}\n" && echo -e " Netflix:\t\t\t\tUnsupport" >> ${LOG_FILE};
        return;
    fi
    
    if [[ "$result" == "curl"* ]];then
        echo -n -e "\r Netflix:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n" && echo -e " Netflix:\t\t\t\tFailed (Network Connection)" >> ${LOG_FILE};
        return;
    fi
    
    local result=`curl -${1} --user-agent "${UA_Browser}" -sL "https://www.netflix.com/title/80018499" 2>&1`;
    if [[ "$result" == *"page-404"* ]] || [[ "$result" == *"NSEZ-403"* ]];then
        echo -n -e "\r Netflix:\t\t\t\t${Font_Red}No${Font_Suffix}\n" && echo -e " Netflix:\t\t\t\tNo" >> ${LOG_FILE};
        return;
    fi
    
    local result1=`curl -${1} --user-agent "${UA_Browser}" -sL "https://www.netflix.com/title/70143836" 2>&1`;
    local result2=`curl -${1} --user-agent "${UA_Browser}" -sL "https://www.netflix.com/title/80027042" 2>&1`;
    local result3=`curl -${1} --user-agent "${UA_Browser}" -sL "https://www.netflix.com/title/70140425" 2>&1`;
    local result4=`curl -${1} --user-agent "${UA_Browser}" -sL "https://www.netflix.com/title/70283261" 2>&1`;
    local result5=`curl -${1} --user-agent "${UA_Browser}"-sL "https://www.netflix.com/title/70143860" 2>&1`;
    local result6=`curl -${1} --user-agent "${UA_Browser}" -sL "https://www.netflix.com/title/70202589" 2>&1`;
    
    if [[ "$result1" == *"page-404"* ]] && [[ "$result2" == *"page-404"* ]] && [[ "$result3" == *"page-404"* ]] && [[ "$result4" == *"page-404"* ]] && [[ "$result5" == *"page-404"* ]] && [[ "$result6" == *"page-404"* ]];then
        echo -n -e "\r Netflix:\t\t\t\t${Font_Yellow}Only Homemade${Font_Suffix}\n" && echo -e " Netflix:\t\t\t\tOnly Homemade" >> ${LOG_FILE};
        return;
    fi
    
    local region=`tr [:lower:] [:upper:] <<< $(curl -${1} --user-agent "${UA_Browser}" -fs --write-out %{redirect_url} --output /dev/null "https://www.netflix.com/title/80018499" | cut -d '/' -f4 | cut -d '-' -f1)` ;
    
    if [[ ! -n "$region" ]];then
        region="US";
    fi
    echo -n -e "\r Netflix:\t\t\t\t${Font_Green}Yes(Region: ${region})${Font_Suffix}\n" && echo -e " Netflix:\t\t\t\tYes(Region: ${region})" >> ${LOG_FILE};
    return;
}



function MediaUnlockTest() {
    MediaUnlockTest_Netflix ${1};
}

echo " ** 正在测试IPv4解锁情况" && echo " ** 正在测试IPv4解锁情况" >> ${LOG_FILE};
check4=`ping 1.1.1.1 -c 1 2>&1`;
if [[ "$check4" != *"unreachable"* ]] && [[ "$check4" != *"Unreachable"* ]];then
    MediaUnlockTest 4;
else
    echo -e "${Font_SkyBlue}当前主机不支持IPv4,跳过...${Font_Suffix}" && echo "当前主机不支持IPv4,跳过..." >> ${LOG_FILE};
fi

echo " ** 正在测试IPv6解锁情况" && echo " ** 正在测试IPv6解锁情况" >> ${LOG_FILE};
check6=`ping6 240c::6666 -c 1 2>&1`;
if [[ "$check6" != *"unreachable"* ]] && [[ "$check6" != *"Unreachable"* ]];then
    MediaUnlockTest 6;
else
    echo -e "${Font_SkyBlue}当前主机不支持IPv6,跳过...${Font_Suffix}" && echo "当前主机不支持IPv6,跳过..." >> ${LOG_FILE};
fi
echo -e "";
echo -e "${Font_Green}本次测试结果已保存到 ${LOG_FILE} ${Font_Suffix}";
cat ${LOG_FILE} | PasteBin_Upload;

RED='\033[0;31m'
PLAIN='\033[0m'
GREEN='\033[0;32m'
Yellow="\033[33m";

# Check if curl is installed
if ! command -v curl &> /dev/null; then
  echo "curl is not installed. Installing curl..."
  if command -v yum &> /dev/null; then
    sudo yum install curl -y
  elif command -v apt-get &> /dev/null; then
    sudo apt-get install curl -y
  else
    echo "Your system package manager is not supported. Please install curl manually."
    exit 1
  fi
fi

# Check if grep is installed
if ! command -v grep &> /dev/null; then
  echo "grep is not installed. Installing grep..."
  if command -v yum &> /dev/null; then
    sudo yum install grep -y
  elif command -v apt-get &> /dev/null; then
    sudo apt-get install grep -y
  else
    echo "Your system package manager is not supported. Please install grep manually."
    exit 1
  fi
fi



function UnlockChatGPTTest() {
    if [[ $(curl --max-time 10 -sS https://chat.openai.com/ -I | grep "text/plain") != "" ]]
    then
        local ip="$(curl -s http://checkip.dyndns.org | awk '{print $6}' | cut -d'<' -f1)"
        echo -e " 抱歉！本机IP：${ip} ${RED}目前不支持ChatGPT IP is BLOCKED${PLAIN}" | tee -a $LOG_FILE
        return
    fi
    local countryCode="$(curl --max-time 10 -sS https://chat.openai.com/cdn-cgi/trace | grep "loc=" | awk -F= '{print $2}')";
    if [ $? -eq 1 ]; then
        echo -e " ChatGPT: ${RED}网络连接失败 Network connection failed${PLAIN}" | tee -a $LOG_FILE
        return
    fi
    if [ -n "$countryCode" ]; then
        support_countryCodes=(T1 XX AL DZ AD AO AG AR AM AU AT AZ BS BD BB BE BZ BJ BT BA BW BR BG BF CV CA CL CO KM CR HR CY DK DJ DM DO EC SV EE FJ FI FR GA GM GE DE GH GR GD GT GN GW GY HT HN HU IS IN ID IQ IE IL IT JM JP JO KZ KE KI KW KG LV LB LS LR LI LT LU MG MW MY MV ML MT MH MR MU MX MC MN ME MA MZ MM NA NR NP NL NZ NI NE NG MK NO OM PK PW PA PG PE PH PL PT QA RO RW KN LC VC WS SM ST SN RS SC SL SG SK SI SB ZA ES LK SR SE CH TH TG TO TT TN TR TV UG AE US UY VU ZM BO BN CG CZ VA FM MD PS KR TW TZ TL GB)
        if [[ "${support_countryCodes[@]}"  =~ "${countryCode}" ]];  then
            local ip="$(curl -s http://checkip.dyndns.org | awk '{print $6}' | cut -d'<' -f1)"
            echo -e " 恭喜！本机IP:${ip} ${GREEN}支持ChatGPT Yes (Region: ${countryCode})${PLAIN}" | tee -a $LOG_FILE
            return
        else
            echo -e " ChatGPT: ${RED}No${PLAIN}" | tee -a $LOG_FILE
            return
        fi
    else
        echo -e " ChatGPT: ${RED}Failed${PLAIN}" | tee -a $LOG_FILE
        return
    fi

}

UnlockChatGPTTest

