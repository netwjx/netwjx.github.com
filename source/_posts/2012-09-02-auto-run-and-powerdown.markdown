---
layout: post
title: "自动运行和关机批处理"
date: 2012-09-02 13:43
comments: true
categories: Bat Cmd Command Shell Windows
---

之前在使用下载软件的完成后自动关机时, 关机失败, 还有导致无法启动, 可能是第三方软件在关机时的实现不够可靠吧. 也懒得找网上专门的自动关机软件, 就写了个自动关机的批处理, 也顺带实现自动运行程序的功能.

使用方式:

-   复制下来用记事本保存为bat文件, 可以放桌面.
-   自动关机

    双点批处理, 按照提示输入要等待的分钟数, 可以输入`3*60+15`这样的数学表达式, 只能是整数, 确定后就会在指定时间之后关机.

-   自动运行程序

    将打算自动运行的程序或快捷方式拖到这个批处理文件上, 然后会出现和自动关机相似的提示, 一样的输入, 确定后不要关闭, 时间到之后会自动运行这个程序并关闭自身.

    命令行下也可以, 第一个参数是要运行的程序, 后续的是要运行程序的参数. 然后按照提示信息来, 和上面的一样.

<!-- more -->

代码部分:

``` bat Auto-Powerdown.bat
@echo off
if "%1"=="" (goto POWERDOWN) else goto RUN

:POWERDOWN
title 自动关机
shutdown /a 2>nul
if not errorlevel 1 (
    echo 已取消上次设置的自动关机
    echo.
)
echo 请输入多久之后关闭计算机?
goto INPUT

:POWERDOWN1
echo 现在时间: %date% %time%, 将在%mins%分钟后关闭计算机.
set /a mins=%mins%*60
shutdown /s /t %mins% >nul 2>&1
echo.
echo 成功, 任意键关闭窗口, 取消自动关机请重新双点 %~nx0.
pause >nul
goto :EOF



:RUN
title %~n1 自动运行
echo 请输入多久之后运行程序
echo   %1
goto INPUT

:RUN1
echo 现在时间: %date% %time%, 将在%mins%分钟后运行程序 %~nx1
echo.
echo 等待中, 请不要关闭当前窗口, 取消自动运行请直接关闭当前窗口.
set /a mins=%mins%*60+1
ping -l 0 -n %mins% 127.0.0.1 >nul
echo.
echo 运行程序 %1
start "" "%1" "%2" "%3" "%4" "%5" "%6" "%7" "%8" "%9"
echo.
echo 成功, 10秒后自动关闭.
ping -l 0 -n 10 127.0.0.1 >nul
goto :EOF


:INPUT
echo 单位:分钟, 例如: 3*60+15 表示3小时15分钟后
set /p str=:
if not defined str goto INPUTERROR

set /a mins=%str%
if %mins% LEQ 0 goto INPUTERROR

if "%1"=="" (goto POWERDOWN1) else goto RUN1


:INPUTERROR
echo 请输入有效的数字, 任意键继续, 退出请直接关闭.
pause >nul
echo.
goto INPUT

```

-   [Windows命令行和批处理技巧](/blog/2012/07/29/windows-shell-and-bat-skills/)