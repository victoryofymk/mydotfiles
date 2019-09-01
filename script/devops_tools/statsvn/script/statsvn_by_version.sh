#!/bin/bash

svn_dir='/Users/yanmingkun/devops_tools/statsvn/statsvn-0.7.0/trunk'
statsvn_dir='/Users/yanmingkun/devops_tools/statsvn/statsvn-0.7.0/statsvn.jar'

log_dir=svnstat
log_file="$log_dir/svnstat.log"
log_day="$log_dir/2014-01-01_00:00:00"

version_start=4150
version_end=4159

function statsvn() {
    cd $svn_dir

    svn up

    if [ ! -d $log_dir ];then
        mkdir $log_dir
    fi

    date=$(date "+%Y-%m-%d_%H:%M:%S")
    echo "$date"

    lines=`find . -name *.java | xargs wc -l | sort -n`
    echo "total code lines : $lines"

    version_end=`svn log -l1 | sed -n 2p | awk '{print $1}' | cut -d "r" -f2`
    echo "version_start : $version_start; version_end : $version_end"
    svn log -v --xml -r$version_start:$version_end > $log_file

    log_day="$log_dir/$date"
    java -jar $statsvn_dir $log_file . -output-dir $log_day > /dev/null 2>&1


    google-chrome $log_day/index.html &
}

statsvn
