#!/bin/bash -
#""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
#          FILE: lines.sh
#
#         USAGE: ./lines.sh [dir]
#         AUTHOR: william
#
#   DESCRIPTION: 基于SVN的代码提交量统计工具
#         EMAIL: lilijreey@126.com
#       OPTIONS: ---
#       CREATED: 06/05/2012 12:49:20 PM CST
#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set -o nounset                              # Treat unset variables as an error


# 关注的文件类型 后罪名
FILES_TYPE="*.cpp *.h *.lua"

# 需要统计的人员,在这里写入需要统计的人,用空格隔开。哈还不智能
declare -r CODER_LIST="coder1 coder2"
declare -i coder1
declare -i coder2


declare -r USAGE="Usage: $0 [dir]. default dir is current dir.\n"

# ERROR CODES;
declare -r E_BAD_PATH=1
declare -r E_INVAILED_ARGU=2
declare -r E_NOT_SVN_DIR=3


#TODO 屏蔽一些dir 还没写哈
# TODO other way get path not with / end
getpath()
{
    #debug
    #echo dir_name: ${dir_name}
    #echo base_name: ${base_name}
    if [ $dir_name == "/" ] || [ $base_name == "/" ]; then
        work_path="/"
    else
        work_path=${dir_name}/${base_name}
    fi
}

statistic_codelines()
{
    if [ -z "$1" ]; then
        echo "ERROR statistic_codelines not argument"
        return
    fi
    local pwd_length=${#PWD}
    echo "--------------------------"
    echo "${PWD}"
    for coder in $CODER_LIST; do
        local num=$(echo "$1" | grep ${coder} | wc -l)
        (( ${coder} +=  num ))
        if [ $num -ne 0 ]; then
            printf "%10s | %-7d\n" ${coder} $num
        fi
    done
    echo "--------------------------"
}


# init check argument set work_path
init_work_path()
{
    if [ $# -eq 1 ]; then
        if [ $1 == "-h" ]; then # is help
                echo -e "$USAGE"
        elif [ -d $1 ]; then
            dir_name=$(dirname ${1})
            base_name=$(basename ${1})
            getpath;
        else
            echo -e "An invailed argument"
            echo -e "Use -h get help."
            exit $E_INVAILED_ARGU
        fi
    fi
}

# check work_path
check_work_path()
{
    if [ -z $work_path ] || [ ! -d $work_path ]; then
        exit $E_BADPATH;
    fi
}

# enter work_path
enter_work_path()
{
    cd ${work_path}
    if [ ! $? ]; then
        echo "Can not enter ${work_path} "
    fi
}

# check work_pat is a svn dir
is_svn_dir()
{
    (
    # check if current dir is asvn dir
    svn info  &> /dev/null
    exit $?
    )
    return $?
}

action()
{
    local dir_name=.
    local base_name=
    local work_path=$dir_name

    init_work_path $1
    check_work_path
    enter_work_path #todo can't enter

    #echo "NOW DIR: $PWD, OLD DIR $OLDPWD"
    is_svn_dir
    #todo to next dir
    local ret=$?
    if [ $ret -ne 0 ]
    then
        echo -e "Current dir \"${work_path}\" not a svn dir."
        exit $E_NOT_SVN_DIR
    fi

    # get source files
    local files=$(ls ${FILES_TYPE} 2> /dev/null)

    if [ -n "$files" ]; then
     local namelist=$(echo -n ${files} |  xargs -n 1 svn blame | awk '{print $2}')
     #svn blame $files #| grep $1 | wc -l
     statistic_codelines "$namelist"
    fi

    local sub_dirs=$(find -maxdepth 1 -type d  -name "[^.]*" 2>/dev/null)

    if [ -n "$sub_dirs" ]; then
        for dir in $sub_dirs ; do
            action "$dir"
        done
    fi

    cd ..
}

total()
{
    echo "-------- TOTOAL ----------"
    echo "     NAME  |  lines       "
    echo "--------------------------"
    for coder in $CODER_LIST; do
        if [ ${!coder} -ne 0 ]; then
            printf "%10s | %-7d\n" ${coder} ${!coder}
        fi
    done
    echo "--------------------------"
}

# main
echo "-----开始统计,请耐心等待.... :) "
action $1
total

exit 0 
