@echo off
rem for /f   %i in ( 'netstat -ano|findstr "7770"')   do  set   PID=%i
rem start cmd /k "taskkill -PID %PID% -F"

rem for /f "tokens=5" %a in ('netstat -ao|findstr "7770"') do @taskkill /F /PID %a  
for /F "tokens=5" %%P IN  ('netstat -a -n -o ^| findstr :7770') DO @taskkill /F /PID %%P
