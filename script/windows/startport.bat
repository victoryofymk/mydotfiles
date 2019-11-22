@echo off
REM 打开CMD
REM D:
REM cd D:\IdeaProjects\research\trust-jindiao-app
REM cmd

D:
REM 登陆并执行
cd D:\IdeaProjects\research\trust-jindiao-app
"D:\Program Files\Git\bin\bash.exe" --login -i -c "./run_jetty.sh"


echo "windows .bat call .shell script""
REM "D:\Program Files\Git\bin\sh.exe" --login -i -c "pwd"
REM  "D:\Program Files\Git\bin\sh.exe" --login -i -c "cp a.txt b.txt"
REM "D:\Program Files\Git\bin\sh.exe" --login -i -c "D:/IdeaProjects/research/trust-jindiao-app/run_jetty.sh"

@echo off
