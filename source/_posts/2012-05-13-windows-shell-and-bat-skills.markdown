---
layout: post
title: "Windows命令行和批处理技巧"
date: 2012-05-13 15:04
comments: true
published: false
categories: Windows Shell Cmd Command Bat
---

有时不想使用通用编程语言完成一些常见的目的, 会考虑使用命令行, 但是命令行的资料不容易找, 因为它中间主要是字母和符号, 基本上搜索引擎会忽略这些特殊符号, 所以这里收集一些这方面的技巧.

下面代码示例中`>`右边表示输入的, 其下一行表示输出, `#`后面的是注释说明


打开命令行
----------

除了`Win+R cmd`打开外, 还可以在文件窗口中按住**Shift + 鼠标右键**, **在此处打开命令窗口**, 在文件夹上**Shift + 鼠标右键**同样有这个菜单项.


<h2 id="multi-commands">在一行执行多个命令</h2>

-   `command1 & command2`

    先执行command1, 然后是command2, 一般在`cmd`开启新的命令控制台时比较有用

        cmd echo 1 && echo 2 && echo 3

-   `command1 && command2`

    先执行command1, 如果执行成功(退出码为0), 将会接着执行command2

-   `command1 || command2`

    和`&&`相反, 如果command1执行失败将会执行command2

-   `(command1 & command2)`

    `()`用于组合嵌入多个命令, 可以在其中使用换行符, 将类似`&`的效果, 只是写成了多行

-   `command1 param1;param2`

    分割命令的参数, 也可以使用符号`,`.


如果命令参数中有`&` `|` `()` `>` `<` `^`则需要使用`^`转义

    >echo ^&
    &


环境变量
--------

set命令用于基本的查看和设置

    >set
    # ......
    USERNAME=netwjx

    >set user
    USERNAME=netwjx

    >set username
    USERNAME=netwjx

    >set myvar=varvalue

同样的, 如果变量值包含`&` `|` `>` `<` `^`, [使用`^`转义符](#multi-commands)

set命令的进一步使用可用来计算数字
    
    >set /p expr=输入时间,单位分钟,例如:5*60+35
    输入时间,单位分钟,例如:5*60+35
    >3*60+11
    >set /a sec=%expr%
    191
    >echo %sec%
    191

使用环境变量

    echo %myvar%> foo.txt

`%myvar%`将会被替换成变量值, 并将这个值输出到`foo.txt`.

在执行一行命令时, `%myvar%`的替换将只会执行一次, 所以在`for` `if`这种语句中, 或者使用`()`组合的多个命令中, 如果变量被修改过, 则需要使用叹号`!`扩住变量名

    set VAR=before
    if "%VAR%" == "before" (
        set VAR=after
        if "!VAR!" == "after" @echo If you see this, it worked
    )


### 获取一个命令行的输出到环境变量

    for /f "usebackq" %i in (`set`) do @echo %i

**注意**, 如果在批处理文件中使用for则需要将`%i`写为`%%i`, 象下面这样

    for /f "usebackq" %%i in (`set`) do @echo %%i

将回显set命令返回的每一行, 配合自定义的命令行程序, 可以弥补[内建环境变量](#built-in-var)中`%date%`和`%time%`格式不固定的问题.


<h3 id="built-in-var">内建环境变量</h3>

内建环境变量是在执行变量替换的时候最先检查的, 其中也有一些比较有用的

-   `%ALLUSERSPROFILE%`

    返回**所有用户**的数据目录, 对于Win7, 它是`C:\ProgramData`

-   `%APPDATA%`

    返回当前用户的应用程序数据存储目录

-   `%CD%`

    返回当前活动目录

-   `%CMDCMDLINE%`

    返回当前命令行解释器的路径, 结果是被双引号`"`括起来的

-   `%CMDEXTVERSION%`

    返回当前命令行处理扩展的版本号

-   `%COMPUTERNAME%`

    返回当前计算机名称

-   `%COMSPEC%`

    和`%CMDCMDLINE%`基本一样, 只是结果不是被双引号`"`括起来的

-   `%DATE%`
    
    返回当前的日期, 格式和`date /t`命令相同, 这个还和系统的区域和语言设置有关, 实际处理起来通用性不是很好.

-   `%ERRORLEVEL%`
    
    返回最近一次命令的执行结果, 一般非0表示发生了错误.

-   `%HOMEDRIVE%`

    返回用户目录所在的盘符, 格式如`C:`

-   `%HOMEPATH%`

    返回用户目录的路径, 不包括盘符, 格式如`\Users\netwjx`

-   `%HOMESHARE%`, `%LOGONSEVER%`

    文档中有, 但是我没测试出来有效值

-   `%NUMBER_OF_PROCESSORS%`

    返回系统的处理器数量

-   `%OS%`
    
    返回操作系统名称, 基本上Win2000以后都是`Windows_NT`

-   `%PATH%`
    
    可执行文件的搜索路径

-   `%PATHEXT%`

    可执行文件后缀

-   `%PROCESSOR_ARCHITECTURE%`

    返回处理器架构, `x86` `IA64`

-   `%PROCESSOR_IDENTIFIER%`
    
    返回处理器描述

-   `%PROCESSOR_LEVEL%`

    返回处理器的系列编号

-   `%PROCESSOR_REVISION%`

    返回处理器的修订编号

-   `%PROMPT%`

    返回当前控制台的提示符, 可以通过`prompt`命令修改

-   `%RANDOM%`

    返回一个随机数字, 范围在0到32767之间

-   `%SYSTEMDRIVE%`

    返回操作系统所在的盘符

-   `%SYSTEMROOT%`

    返回操作系统的根路径, 包含盘符

-   `%TEMP%` `%TMP%`
    
    返回当前用户的临时目录

-   `%TIME%`

    返回当前的时间, 格式类似`time /t`命令返回的, 这个还和系统的区域和语言设置有关, 实际处理起来通用性不是很好.

-   '%USERDOMAIN%'

    返回当前用户所在的域, 或工作组名

-   `%USERNAME%`

    返回当前登录的用户

-   `%USERPROFILE%`

    返回当前用户目录

-   `%WINDIR%`

    返回当前操作系统的路径, 类似`%SYSTEMROOT%`

在内建环境变量中没有指定名称的变量后, 会依次从下面的位置查找

-   系统变量
-   当前用户变量
-   Autoexec.bat 中定义的变量
-   登录脚本中定义的变量(如果有提供登录脚本)
-   当前命令控制台或批处理中定义的变量


管道和重定向
------------

TODO


在多个目录间切换工作目录
------------------------

    >pushd d:\foo

将当前工作目录保存后, 立即将工作目录切换到`d:\foo`.

    >popd

将当前工作目录切换到最近一次`pushd`时所在的工作目录.

很典型的一个栈stack结构, push和pop.

比`cd`命令好用的是`cd`在跨盘符的时候还需要手工切换盘符.


延迟 Sleep
----------

    ping -n 4 -w 1000 127.0.0.1 > nul

这将会延迟3秒, 其中`-n`参数表示的是重复ping的次数, 将决定最终的延迟的时间.

因为`ping 127.0.0.1`会立即返回, 所以实际延迟的时间是 `-n`参数 - 1 的秒数.


echo特殊字符
------------

一般使用`%`作为转义字符

    >echo %username%
    netwjx

    >echo %%username%
    %netwjx

但是`&` `|`需要使用`^`转义, 这个在上面[在一行执行多个命令](#multi-commands)已经有描述

    >echo ping -n 3 127.0.0.1^>nul
    ping -n 3 127.0.0.1^>nul

    >echo netstat -ano^|find ":80"
    netstat -ano|find ":80"

P.S. Linux下echo转义符号是`\`

空行, 在echo紧跟`.`

    >echo.

使用echo和输出重定向可以产生文本文件, 可以用来产生脚本批处理等.


批处理文件
----------

批处理文件可以是`bat`后缀, 也可以是`cmd`后缀.

批处理文件需要保存为ANSI格式, 对于中文Windows是GBK, 不建议用**UTF-8**, 也不建议有**BOM**


### 不回显输入的命令

以`@`开始的命令将不会回显

    @echo hello

同时可以使用`echo off`关闭回显, 如果两者结合的话就是

    @echo off

一般在批处理文件第一行, 可以使所有命令都不回显.

一般调试时可能会需要在某行之后回显, 可以再`echo on`打开回显.


### 批处理参数

使用`%1`到`%9`获取, 其中`%0`是当前批处理文件的路径.

``` bat Foo\test.bat
@echo off
echo %0
echo %1
echo %2
echo %3
echo %4
```

使用示例

    >Foo\test.bat 1 2 3 4
    Foo\test.bat
    1
    2
    3
    4

`%0` 可用来删除脚本自身, 不过这行必须放结尾, 因为一旦删除就会脚本执行出错.

可以用if检测参数是否提供

    >if not "%4"=="" echo %4

1-9不够用可以使用`shift`

    >shift
    # 将参数队列弹出一个, 这将会使旧的%1值被移除, 旧的%2变成%1, 旧的%3变成%2
    >shift /2
    # 和上面的类似, 只是一次弹出2个, 旧的%1 %2被移除, 旧的%3 %4 %5将变成%1 %2 %3


### 参数修饰符

参数修饰可以将指定参数扩展为文件或目录名, 使用当前的盘符和目录信息.

    >echo %~dp1 # 把%1参数扩展为包含盘符和路径的字符串

完整的修饰符列表

-   `%~1`

    扩展%1参数并移除参数两边的双引号`"`

-   `%~f1`

    扩展%1参数为完整的路径

-   `%~d1`

    扩展%1参数为盘符

-   `%~p1`

    扩展%1参数为路径, 不包括盘符和文件名

-   `%~n1`

    扩展%1参数为文件名, 不包括扩展名

-   `%~x1`

    扩展%1参数为扩展名, 包含点

-   `%~s1`

    扩展%1参数为仅包含短名称目录名的路径

-   `%~a1`

    扩展%1参数为文件属性, 格式如`--a------`, 其它标志位的字母可以自行测试

-   `%~t1`

    扩展%1参数为文件修改时间, 格式如`2011/07/31 17:04`

-   `%~z1`

    扩展%1参数为文件大小的数字, 单位字节

-   `%~$PATH:1`

    在PATH环境变量中指定的所有目录中(分号`;`分割的目录路径)搜索名为%1的文件名, 返回第一个发现的文件路径, 如果环境变量不存在或者找不到文件, 将返回空白的字符串

上述的修饰符和多重叠加

    %~dp$PATH:1 # 搜索PATH环境变量的路径中名为%1的文件, 并返回第一个找到的文件的盘符和路径


### 调用其它批处理

一般是可以直接`other.bat`, 但是可能会发生一些奇怪的现象, 如后续的命令未执行之类的, 所以

    call other.bat arg1 arg2


### goto跳转到标记

和传统编程语言中的用法一样

    if "%1"=="" goto help

    echo running
    # .....
    goto end

    :help
    echo help message
    goto :EOF

    :end
    echo completed

标记使用`:label`来定义, 然后是`goto label`跳转.

有一个特殊标记`:EOF`表示结束, 使用时是`goto :EOF`.


参考链接
--------

-   [Using batch parameters](http://www.microsoft.com/resources/documentation/windows/xp/all/proddocs/en-us/percent.mspx)

-   [Cmd](http://www.microsoft.com/resources/documentation/windows/xp/all/proddocs/en-us/cmd.mspx)

-   [Command shell overview](http://www.microsoft.com/resources/documentation/windows/xp/all/proddocs/en-us/ntcmds_shelloverview.mspx)
