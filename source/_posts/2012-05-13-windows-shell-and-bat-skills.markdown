---
layout: post
title: "Windows命令行和批处理技巧"
date: 2012-06-16 23:23
comments: true
categories: Windows Shell Cmd Command Bat
---

有时不方便使用通用编程语言完成一些常见的目标, 会考虑使用命令行, 但是命令行的资料不容易找, 主要因为它有不少是字母和符号, 基本上搜索引擎会忽略这些特殊符号, 所以这里收集一些这方面的技巧.

下面代码示例中`rem`表示对下一行的注释, 一般下一行以`>`开始, 表示在命令提示符中输入的, 再下一行表示大概的输出. 整块的代码一般是文件内容, 将会以文件中的形式表现.


打开命令行
----------

除了`Win+R cmd`打开外, 还可以在文件窗口中按住**Shift + 鼠标右键**, **在此处打开命令窗口**, 在文件夹上**Shift + 鼠标右键**同样有这个菜单项.

<!-- more -->

<h2 id="multi-commands">在一行执行多个命令</h2>

-   `command1 & command2`

    先执行command1, 然后是command2, 一般在`cmd`开启新的命令提示符窗口时比较有用

        cmd echo 1 && echo 2 && echo 3

-   `command1 && command2`

    先执行command1, 如果执行成功(退出码为0), 将会接着执行command2

-   `command1 || command2`

    和`&&`相反, 如果command1执行失败将会执行command2

-   `(command1 & command2)`

    `()`用于组合嵌入多个命令, 可以在其中使用换行符, 将类似`&`的效果, 只是写成了多行, 在`for`和`if`中很有用

        if not defined foo (
            set foo = bar
        )

-   `command1 param1;param2`

    分割命令的参数, 也可以使用符号`,`.


如果命令参数中有`&` `|` `()` `>` `<` `^`则需要使用`^`转义

    >echo ^&
    &


环境变量
--------

set命令用于基本的查看和设置环境变量

    >set
    ....
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

    >echo %myvar%> foo.txt

`%myvar%`将会被替换成变量值, 并将这个值输出到`foo.txt`.

检测环境变量是否有定义

    if not defined foo (
        echo need %foo%
    )

在执行一行命令时, `%myvar%`的替换将只会执行一次, 所以在`for` `if`或者`()`组合的多个命令中, 如果变量被修改过, 则需要使用叹号`!`扩住变量名

    set VAR=before
    if "%VAR%" == "before" (
        set VAR=after
        if "!VAR!" == "after" @echo If you see this, it worked
    )

在`for`的`do`部分, 只有`for`的循环变量是个特例, 每次执行循环都会被替换为循环变量


### 获取一个命令行的输出到环境变量

执行`set`命令, 并将每行的内容作为循环变量%i输出

    >for /f %i in ('set') do @echo %i
    ...
    windir=C:\windows

有时可能不方便使用单引号`'`, 可以使用反引号`` ` ``

    >for /f "usebackq" %i in (`set`) do @echo %i
    ...
    windir=C:\windows

更多关于[`for`命令](#for-command)


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

    返回当前命令提示符窗口的提示符, 可以通过`prompt`命令修改

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

-   `%USERDOMAIN%`

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
-   当前命令提示符窗口或批处理中定义的变量


管道和重定向
------------

一个常见的场景, 查找使用特定网络端口的应用程序

    >netstat -ano | find ":4000"
      UDP    0.0.0.0:4000           *:*                                    3876

其中最右边的**3876**是应用程序的进程ID, 而`|`是管道操作符.

管道操作将会把左边命令的输出, 作为右边命令的输入. 上面例子中`netstat -ano`将会输出本机的网络连接和对应的进程, `find ":4000"`则是在输入中找包含字符串`:4000`的行.

重定向和管道也很相似, 典型的用途是将一个命令的输出保存为文本文件.

    >netstat -ano > foo.txt

可以在当前目录中看到`foo.txt`, 其内容是`netstat -ano`命令的输出.

可以和管道操作结合, 将查出来的本地网络连接信息保存到文件

    ?netstat -ano | find ":4000" > foo.txt

`>`会始终覆盖原来的文件, 使用`>>`则会在文件结尾添加

    >netstat -ano >> foo.txt

随着反复的运行, `foo.txt`的结尾会一直增加.

有一个特殊的管道目标叫`clip`, 可以用来操作系统剪贴板

还有一个特殊的输出设备叫`nul`, 它不会产生任何文件, 效果就像执行了命令, 但是不回显命令的输出, 在[延迟 Sleep](#sleep-ping)有这个例子.

上述可以将命令正常执行的结果重定向到文件, 但是错误信息仍旧会输出到命令提示符窗口(**标准输出**)

    >netstat -x > nul

    显示协议统计和当前 TCP/IP 网络连接。

    NETSTAT [-a] [-b] [-e] [-f] [-n] [-o] [-p proto] [-r] [-s] [-t] [interval]
    ....

默认错误信息输出的目标叫**标准错误输出**, 仍旧可以让其不显示

    >netstat -x > nul 2>&1

其中`>&`也是重定向操作符, 需要配合`>` `>>`使用, 2**标准错误输出**, 1表示**标准输出**.

`> nul 2>&1`表示在将标准输出重定向到`nul`的同时将**标准错误输出**重定向到**标准输出**, 这样就完成了完全隐藏命令行输出的正常信息和错误信息. 

关于重定向的数字下面是完整的参考

-   `0` STDIN

    标准输入, 键盘输入

-   `1` STDOUT

    标准输出, 命令提示符窗口输出

-   `2` STDERR
    
    标准错误输出, 命令提示符窗口输出

-   `3-9` UNDEFINED

    未定义, 参考文档中描述其在特定应用程序中会使用, 但是没找到具体使用的例子, 所以我目前也不清楚具体使用是怎么样的.

如果仅想取得命令的错误信息可以这样

    >netstat -x 2> foo.txt

在[参考链接](#ref-links)中**Using filters**有管道和重定向混合使用示例.


### 输入重定向

上面的重定向都是输出重定向, 这里开始介绍输入重定向.

在介绍管道的时候使用了`find`命令, 它会在**标准输入**中查找指定字符串, 除了使用管道外, 还可以使用输入重定向

    > netstat -ano > foo.txt
    > find ":4000" < foo.txt
      UDP    0.0.0.0:4000           *:*                                    3876

这会使用中间文件`foo.txt`

而**标准输入**实际是个特殊的输入设备`con`

    >find "foo" < con

等价于

    >find "foo"

每当输入包含foo的字符串并回车后, 会立即回显一次.

比如使用用户输入来创建文件

    >copy con foo.txt
    >bar
    >hello world
    >^Z
    已复制         1 个文件。

其中`^Z`表示`Ctrl+Z`, 输入结束.

除了`find`会使用标准输入外, 常见的还有下列命令也会使用标准输入

-   `more`
    
    用于逐屏显示标准输入

-   `sort`

    按行排序标准输入

还有一个`<&`重定向操作符, 文档中的解释是会从右边的设备读取输入, 并从左边输出, 我实在想不出来这具体是在什么场景下使用, 所以也不知道如何介绍.

在[参考链接](#ref-links)中**Using filters**有管道和重定向混合使用示例.


在多个目录间切换工作目录
------------------------

    >pushd d:\foo

将当前工作目录保存后, 立即将工作目录切换到`d:\foo`.

    >popd

将当前工作目录切换到最近一次`pushd`时所在的工作目录.

很典型的一个栈stack结构, push和pop. stack为空时pop将没有任何效果.

比`cd`命令好用的是`cd`在跨盘符的时候还需要手工切换盘符.


<h2 id="sleep-ping">延迟 Sleep</h2>

    >ping -n 4 -w 1000 127.0.0.1 > nul

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


<h2 id="for-command">for命令</h2>

如果在批处理文件中使用`for`则需要将`%i`写为`%%i`, 象下面这样

    >for /f %%i in ('set') do @echo %%i

使用`for`命令的循环变量时, 可以使用类似批处理哪样的[参数修饰符](#batch-param-modifiers)

    >for %I in (*.log) do @echo %~nxI
    log.log
    ....

下面例子将使用在命令提示符窗口中的写法, 而不是批处理文件中的写法.

`for`命令一般是用于处理多个文件, 文件的多行, 也可以用于处理另外一个命令的输出. 下面是显示`*.log`文件的例子
    
    >for %i in (*.log) do @echo %i
    C:\Log\log.log
    ....

匹配目录
    
    >for /d %i in (.*) do @echo %i
    .svn
    ....

枚举当前目录所有**.txt**文件

    >for /r %i in (*.txt) do @echo %i
    C:\foo.txt
    C:\bar\foo.txt
    ....

枚举所有名字以`.`开始目录, 主要是指`.svn .hg`这些

    >for /d /r %i in (.*) do @echo %i
    C:\Users\Netwjx\.ssh
    ....

数字的循环变量

    >for /l %i in (0, 1, 5) do @echo %i
    0
    1
    2
    3
    4
    5

注意初始值`0`和最大值`5`, 都会包含在内, 也就是这个循环将执行**6次**.

显示文件中的每行, 从开始到第一个空格到`tab`之间的字符串

    >for /f %i in (mylog.log) do @echo %i
    15:07:50.947:
    15:07:50.947:
    15:07:50.947:
    ....

`/f`还可以使用一些参数, 下面将会把`path`环境变量的第一个`;`之前的内容输出

    >for /f "usebackq delims=;= tokens=2" %i in (`set path`) do @echo %i
    C:\Ruby\bin
    .COM

详细参数如下, 空格分割

-   `eol=c`

    指定行注释字符, 以`c`字符开始的行将被忽略

-   `skip=n`

    指定忽略开始的n行

-   `delims=xxx`

    指定分割字符, 可以指定多个, 配合`tokens`参数使用, 类似传统编程语言中`split`函数的分割字符

-   `tokens=x,y,m-n`

    将`x y`以及`m-n`之间的字符串返回给循环变量, 下标从1开始, 如果有`y*`, 则表示从第`y`个往后的所有都返回, 下一段有详细的使用示例.

-   `usebackq`

    表示使用`` ` ``符号表示一个命令行, 而不是传统的`'`符号

配合自定义的命令行程序, 可以自行处理命令提示符窗口的输入和输出, 以及弥补[内建环境变量](#built-in-var)中`%date%`和`%time%`格式不固定的问题.


### 使用for的tokens参数

`tokens`参数可以用来提取命令行或文件的返回值, 最基本的如:

    >for /f "tokens=2" %i in ("1 2 3 4 5 6 7 8") do @echo %i
    2

`tokens`可以指定多个, 会隐式的将对应索引的值赋给按照字母顺序命名的循环变量:

    >for /f "tokens=2,4,6-8" %i in ("1 2 3 4 5 6 7 8") do @echo %i %j %k %l %m %n
    2 4 6 7 8 %n

可以看到`tokens=2,4,6-8`分别会给`%i %j %k %l %m`赋值, 而`%n`则原样显示.

还有`y*`的例子

    >for /f "tokens=2*" %i in ("1 2 3 4 5 6 7 8") do @echo %j %k
    3 4 5 6 7 8 %k
    >for /f "tokens=2*" %i in ("1 2 3 4 5 6 7 8") do @echo %i %j %k
    2 3 4 5 6 7 8 %k

`2*`将会把从第2个开始(不包括)往后所有的都赋给了`%j`


### 查询注册表

这是个使用`for`执行命令并取得命令执行结果到变量的典范.

    >for /f "tokens=3 skip=2" %i in ('reg query HKEY_CLASSES_ROOT\txtfile\shell\open\command /ve') do @echo %i
    C:\windows\notepad.exe

其中`reg query`命令是读取注册表, 返回的内容类似下面
    
    HKEY_CLASSES_ROOT\txtfile\shell\open\command
    (默认)    REG_SZ    C:\windows\notepad.exe %1

因为其开始会有一个空行, 所以`/f`参数有`skip=2`


批处理文件
----------

批处理文件可以是`bat`后缀, 也可以是`cmd`后缀.

批处理文件需要保存为ANSI格式, 对于中文Windows是GBK, 不建议用**UTF-8**, 也不建议有**BOM**


### 不回显输入的命令

以`@`开始的命令将不会回显

    >@echo hello

同时可以使用`echo off`关闭回显, 如果两者结合的话就是

    >@echo off

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

可以用`if`检测参数是否提供

    >if not "%4"=="" echo %4

1-9不够用可以使用`shift`

    >rem 将参数队列弹出一个, 这将会使旧的%1值被移除, 旧的%2变成%1, 旧的%3变成%2
    >shift
    >rem 和上面的类似, 只是一次弹出2个, 旧的%1 %2被移除, 旧的%3 %4 %5将变成%1 %2 %3
    >shift /2

如果仅需要将当前的参数原封不动的传递给别的命令行程序, 使用`%*`

    >call foo.bat %*

`%*`将包含原始的`%1-%n`的参数, 不受`shift`影响, `%*`**不能使用**[参数修饰符](#batch-param-modifiers)


<h3 id="batch-param-modifiers">参数修饰符</h3>

参数修饰可以将指定参数扩展为文件或目录名, 使用当前的盘符和目录信息.

    >rem 把%1参数扩展为包含盘符和路径的字符串
    >echo %~dp1

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

    >rem 搜索PATH环境变量的路径中名为%1的文件, 并返回第一个找到的文件的盘符和路径
    >echo %~dp$PATH:1


### 调用其它批处理

一般是可以直接`other.bat`, 但是可能会发生一些奇怪的现象, 如后续的命令未执行之类的, 所以

    >call other.bat arg1 arg2


### goto跳转到标记

和传统编程语言中的用法一样

    if "%1"=="" goto help

    echo running
    ....
    goto end

    :help
    echo help message
    goto :EOF

    :end
    echo completed

标记使用`:label`来定义, 然后是`goto label`跳转.

有一个特殊标记`:EOF`表示结束, 使用时是`goto :EOF`.


<h2 id="ref-links">参考链接</h2>

-   [Using batch files](http://www.microsoft.com/resources/documentation/windows/xp/all/proddocs/en-us/batch.mspx?mfr=true)

-   [Using batch parameters](http://www.microsoft.com/resources/documentation/windows/xp/all/proddocs/en-us/percent.mspx)

-   [Using command redirection operators](http://www.microsoft.com/resources/documentation/windows/xp/all/proddocs/en-us/redirection.mspx?mfr=true)

-   [Using filters](http://www.microsoft.com/resources/documentation/windows/xp/all/proddocs/en-us/filters.mspx?mfr=true)

-   [Cmd](http://www.microsoft.com/resources/documentation/windows/xp/all/proddocs/en-us/cmd.mspx)

-   [Command shell overview](http://www.microsoft.com/resources/documentation/windows/xp/all/proddocs/en-us/ntcmds_shelloverview.mspx)

