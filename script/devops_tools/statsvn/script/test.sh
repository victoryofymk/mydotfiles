#!/usr/bin/env bash

log_file="/Users/yanmingkun/Documents/crontab.log"

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

# exec 1>>$log_file
# exec 2>>$log_file

echo `date '+%Y-%m-%d %H:%M:%S'` 开始执行...
cd 1234
./search.sh
echo "测试一下"

send_email
