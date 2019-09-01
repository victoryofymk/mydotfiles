#!/usr/bin/env bash

# svn代码统计工具，svn_path：项目路径

# svn_path="/Users/yanmingkun/IdeaProjects/utboss/FBOSS_PROJECT/code/utboss/trunk"
# svn_path="/Users/yanmingkun/IdeaProjects/FOSS_GS_20180503_1.4.0.026"
# svn_path="/Users/yanmingkun/Downloads/foss-nx/trunk"
# svn_path="/Users/yanmingkun/IdeaProjects/foss-bill"
svn_path="/Users/yanmingkun/IdeaProjects/FOSS1.0.0.0_SN"
# svn_path="/Users/yanmingkun/IdeaProjects/FOSS1.5.0.0"
# svn_path="/Users/yanmingkun/IdeaProjects/SERVER/tmms/trunk"

statsvn_path="/Users/yanmingkun/github/mydotfiles/script/devops_tools/statsvn"
root_path="statsvn_by_time"

#邮箱开始
from='statsvn_code_count@atuo.com'
to='yanmingkun@aspirecn.com'

email_date=''
email_content='/Users/yanmingkun/github/mydotfiles/script/devops_tools/statsvn/result/statsvn_by_time/charts/index.html'
email_link="<p><a href="file://$email_content">$email_content</a></p>"
email_subject='statsvn_code_count'
# count_start_date = $(date "+%Y-%m-%d")
# count_end_date = $(date -v -6d +%Y-%m-%d)

function send_email(){
    email_date=$(date "+%Y-%m-%d %H:%M:%S")
    echo $email_date

    # email_subject=$email_subject"__"$email_date
    echo $email_subject
    #发送html格式代码
    ( echo "From: $from";echo "To: $to";echo "Subject: $email_subject"; echo "Content-Type: text/html;charset=UTF-8"; echo "Content-Disposition: inline"; echo "执行开始时间：$email_date ";echo "输出文件：$email_link";cat $email_content; ) | /usr/sbin/sendmail -t
    # cat $email_content | formail -I "From: $from" -I "MIME-Version:1.0" -I "Content-type:text/html;charset=gb2312" -I "Subject: $email_subject" | /usr/sbin/sendmail -oi $to

}
#邮箱结束

cd $statsvn_path

if [ ! -d "/result/$root_path/log" ]; then
mkdir -p result/$root_path/log
fi

svn update $svn_path --username yanmingkun --password -h68s1eQ


echo "---------------------开始生成日志---------------------"
svn log $svn_path -v --xml -r  {$(date -v -5d +%Y-%m-%d)}:{$(date -v +1d +%Y-%m-%d)} > result/$root_path/log/svn.log
# svn log $svn_path -v --xml -r  {2018-01-01}:{2018-12-31} > result/$root_path/log/svn.log

echo "---------------------结束生成日志---------------------"

if [ ! -d "/result/$root_path/charts" ]; then
mkdir -p result/$root_path/charts
fi

cd result/$root_path/charts

java -jar $statsvn_path/statsvn-0.7.0-update1/statsvn.jar $statsvn_path/result/$root_path/log/svn.log $svn_path  -charset utf-8 -disable-twitter-button -title trunk-statsvn-by-time  -include **/*.java:**/*.js:**/*.jsp:**/*.xml -exclude **/sqlite3/*.*:**/*.iml


send_email
