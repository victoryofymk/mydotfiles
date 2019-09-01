#!/usr/bin/env bash


svn_path="/Users/yanmingkun/IdeaProjects/utboss/FBOSS_PROJECT/code/utboss/trunk"
statsvn_path="/Users/yanmingkun/devops_tools/statsvn"
root_path="statsvn"
#邮箱开始
from='statsvn_code_count@atuo.com'
to='yanmingkun@aspirecn.com'

email_date=''
email_content='/Users/yanmingkun/devops_tools/statsvn/result/statsvn/charts/index.html'
email_link="<p><a href="file://$email_content">$email_content</a></p>"
email_subject='statsvn_code_count'

function send_email(){
    email_date=$(date "+%Y-%m-%d %H:%M:%S")
    echo $email_date

    # email_subject=$email_subject"__"$email_date
    echo $email_subject
    #发送html格式代码
    ( echo "From: $from";echo "To: $to";echo "Subject: $email_subject"; echo "Content-Type: text/html"; echo "Content-Disposition: inline"; echo "执行开始时间：$email_date ";echo "输出文件：$email_link";cat $email_content; ) | /usr/sbin/sendmail -t
    # cat $email_content | formail -I "From: $from" -I "MIME-Version:1.0" -I "Content-type:text/html;charset=gb2312" -I "Subject: $email_subject" | /usr/sbin/sendmail -oi $to

}
#邮箱结束
cd $statsvn_path

if [ ! -d "/result/$root_path/log" ]; then
mkdir -p result/$root_path/log
fi

svn update $svn_path --username yanmingkun --password -h68s1eQ

echo "---------------------开始生成日志---------------------"
svn log $svn_path -v --xml > result/$root_path/log/svn.log
echo "---------------------结束生成日志---------------------"

if [ ! -d "/result/$root_path/charts" ]; then
mkdir -p result/$root_path/charts
fi

cd result/$root_path/charts

java -jar $statsvn_path/statsvn-0.7.0/statsvn.jar $statsvn_path/result/$root_path/log/svn.log $svn_path  -charset utf-8 -disable-twitter-button -title trunk-statsvn  -include **/*.java:**/*.js:**/*.jsp:**/*.xml -exclude **/sqlite3/*.*
