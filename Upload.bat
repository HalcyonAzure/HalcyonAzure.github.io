@echo off
set /p commit=Input Commit:
git add .
git commit -m "%commit%"
git push
pause