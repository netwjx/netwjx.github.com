---
layout: post
title: "Octopress 笔记"
date: 2012-03-18 14:43
comments: true
categories: 
---

Octopress是一个blog框架, 基于Jekyll, 但是增加了很多方便的脚本, 并提供和github集成.

blog是生成静态页, 配合github-pages可以使用默认的2级域名或者绑定自己的顶级域名使用, 当然也可以部署到自己的服务器上.

这里主要是以我自己的环境来写, 即在Windows下使用Octopress. 因为Win下折腾这个中间出的问题很多.


安装前提
========

Octopress使用ruby编写, 所以需要ruby, Win下使用RubyInstaller

* <http://rubyinstaller.org> 因为神奇的原因我这里无法访问它.
* <http://rubyforge.org/projects/rubyinstaller/> 这里可以下载到, 我现在看到的RubyInstaller最高版本是1.9.3-p125

上面的网页先别关, 还有一个devkit需要下载, 全称Development Kit, 用途是编译一些ruby中使用的c模块, 常见的比如sqlite

那么下载的文件有

* rubyinstaller-1.9.3-p125.exe
* devkit-3.4.5r3-20091110.7z

Octopress可以到<https://github.com/imathis/octopress> 下载一份zip包, 如果已经有git环境则直接

    git clone git://github.com/imathis/octopress.git myoctopress

我这里使用git, 那么应该会得到一个文件夹(下面提到将名为myoctopress目录), 内容和<https://github.com/imathis/octopress> 上显示的一样

前期准备基本完成, 如果没有git而打算使用git看下段


没有git, 打算使用git
-------------------

Win下使用简单的git是TortoiseGit

* <http://code.google.com/p/tortoisegit/> 因为神奇的原因它可能有时会无法访问
* <http://goo.gl/ZpyYx> 我在金山快盘的共享, 密码为IYzDsp

由于TortoiseGit的后端使用的是Git for Windows <http://code.google.com/p/msysgit/> , 所以下载的文件有

* TortoiseGit-1.7.6.0-32bit.msi
* Git-1.7.8-preview20111206.exe

版本可能不同, 名字应该都是相似的, 先安装`Git-1.7.8-preview20111206.exe`, 然后是`TortoiseGit-1.7.6.0-32bit.msi`, 然后右键菜单中就有TortoiseGit项了.

建议将Git for Windows安装目录的bin目录加入到环境变量Path中, 默认是`C:\Program Files\Git\bin`, 因为Octopress中会使用系统中的git命令


安装Ruby
=============

`rubyinstaller-1.9.3-p125.exe`建议安装到`c:\ruby`, 因为devkit中的默认配置就是这个路径

确保`C:\Ruby\bin`在你的环境变量Path中, 下面使用的ruby gem命令都需要

然后是devkit-3.4.5r3-20091110.7z解压到`c:\ruby`.

如果不是这个路径, 解压之后还需要到`devkit\msys\1.0.11\etc\fstab`修改文件内容.

如果路径包含空格, 则需要将路径转换成8.3格式短文件名, 方法是`dir /-n`, 就可以看到8.3格式的

建议将`C:\Ruby\devkit\msys\1.0.11\bin`也加入到环境变量Path中, 可以避免后续在安装ruby的fsevent模块时出现一个没有找到命令行的错误

可以运行`C:\Ruby\devkit\msys\1.0.11\msys.bat`看看, 这个是msys的环境, 一个最小的UNIX环境, 类似Cygwin, 但是原理不同, 更快, 更小, 前面Git for Windows也是基于这个.

打开`C:\Ruby\lib\ruby\1.9.1\i386-mingw32\rbconfig.rb`, 找到62行附近, 查找`-Wno-missing-field-initializers`, 将其删除, 我这里是复制一份新的修改并注释原来的

    #CONFIG["warnflags"] = "-Wextra -Wno-unused-parameter -Wno-parentheses -Wpointer-arith -Wwrite-strings -Wno-missing-field-initializers -Wno-long-long"
    CONFIG["warnflags"] = "-Wextra -Wno-unused-parameter -Wno-parentheses -Wpointer-arith -Wwrite-strings -Wno-long-long"

这么做可以避免在安装ruby的本地c模块时调用gcc失败的问题, 我遇到的是无法安装RedCloth模块, 可能是devkit里面附带的gcc版本旧, 不支持这个选项吧.


修改gem的源服务器地址
--------------------

因为神奇的原因gem可能会下载任何东西失败, 修改后可解决这个问题

gem是ruby的包管理程序, 类似debian的apt-get

打开命令行

    gem sources --remove http://rubygems.org/
    gem sources -a http://ruby.taobao.org/
    gem sources -l
    *** CURRENT SOURCES ***

    http://ruby.taobao.org

最后一个命令`gem sources -l`是查看当前的配置, 确保输出和上述的一致


安装Octopress
=============

前面那么多准备都是为了这里, 主要参考http://octopress.org/docs/setup/.

下述的命令行工作目录都是在myoctopress目录, 为了方便, 你可以在myoctopress目录创建一个cmd.cmd, 内容是

    @start

命令行

    gem install bundler

会需要一会时间, 完成后打开myoctopress目录下的Gemfile, 将`source "http://rubygems.org"`注释掉, 添加`source 'http://ruby.taobao.org/'`, 如下

    #source "http://rubygems.org"
    source 'http://ruby.taobao.org/'

这样可以让bundle不会因为神奇的原因而容易出错, 然后命令行

    bundle install

这会安装Octopress相关依赖的包, 比前一个命令需要更多的时间, 如果打算使用github的话可以看看下一段.

`bundle install`执行完毕后再

    rake install

这个会创建好相关的目录结构

接下来是设置如何部署, 参考<http://octopress.org/docs/deploying/>, 我这里使用github


github上创建代码库
------------------

<http://pages.github.com> 上有详细的说明, 我使用的是User Pages, 比如我的用户名是netwjx, 那么创建项目 netwjx.github.com

后续还有关于域名绑定什么的就不多说了, 主要是修改CNAME记录和A记录的

创建好之后能看到其git访问的地址, 比如我是 `git@github.com:netwjx/netwjx.github.com.git`

按照github上的说明将提交用的ssh public key都折腾好, 如果以前用过github最好


设置部署github
================

参考<http://octopress.org/docs/deploying/github/> , 命令行

    rake setup_github_pages

输入git的地址,比如我的是 `git@github.com:netwjx/netwjx.github.com.git`

然后这个命令

* 会把myoctopress中原来clone时的代码库origin改名为octopress,并将刚刚输入git地址作为origin的代码库地址.
* 会把当前分支名称从master改为source
* 其它Url的设置还有deploy目录设置等

中间需要用到git命令, 所以之前安装Git for Windows后必须将其`bin`目录加入到Path中

中间可能会在`My Octopress Page is coming soon`之后出现`hellip;`不是内部命令之类的错误, 可以不用管, 如果一定不想要出现这个错误可以修改myoctopress目录下的Rakefile, 搜`My Octopress Page is coming soon`, 在`&hellip;`前加个` ^ `(这个是Windows cmd的转义符), 如下

    system "echo 'My Octopress Page is coming soon ^&hellip;' > index.html"

`rake setup_github_pages`命令最后出现``Now you can deploy to xxxxxxx with `rake deploy` ``, 就表示成功.

接下来

    rake generate

将会在myoctopress的public目录中生成静态的文件, 可以使用下面的命令预览

    rake preview

通过<http://localhost:4000>来访问, 现在应该只能看到空白的网站.


第一篇blog
==========

参考<http://octopress.org/docs/blogging/>

    rake new_post["title"]

将会在`source/_posts`目录中创建指定名称的markdown文件, 文件名前面会自动加上年月日. title不能有中文, 因为这个名字会在url中使用, 中文标题可以打开这个markdown文件后自行修改, 刚刚创建的markdown文件内容如下

    ---
    layout: post
    title: "title"
    date: 2012-03-18
    comments: true
    categories:
    ---

这段除了title改成自己需要的, 别的可以先不管, 详细的见这段开始提到的参考.

如果刚刚没关闭`rake preview`, 那么现在浏览<http://localhost:4000>应该能看到有了新的变化.


提交到github
============

先把`rake preview`关掉, 命令行

    rake deploy

如果是直接使用TortoiseGit, 而不是Git for Windows的话, 这里将会因为ssh配置相关而发生错误. 修改配置会另起一篇来说, 这里可以自行使用TortoiseGit来提交.

先说明一下目录的情况

* `myoctopress` 是source分支
* `myoctopress/_deploy` 是master分支

如果仅仅需要看到网站, 只需要在`myoctopress/_deploy`目录中用TortoiseGit的`Git Sync`, Remote Branch选择`master`, 然后Push即可


如果同时需要将原始的markdown等文件也提交到github, 就是在`myoctopress`目录做类似的操作.

先在`myoctopress`目录中把已经修改的文件和`source\_posts`目录下的新文件都`Git Commit -> "source"`

然后`Git Sync`, 在Remote Branch选择`source`, 如果没有这个分支就自己填上, 再Push.

如果Push请确认`Git Sync`时的Remote URL设置的是`origin`, 另外一个`octopress`是Octopress项目的Url, 所以Push会失败, 除非你获得了操作Octopress项目的权限.


结构说明
-------------

github上的`master`(网站)和`source`(原始文件), 与本地的对应分支/目录是平等的关系, 上面提交到github不能理解为从属关系, 了解git的话这个很容易理解.

可以按照需要将`myoctopress/_deploy` (master分支) 目录放到任何Web服务器(当然会有一些绝对路径有问题)

同样`myoctopress`(source分支)可以不向github上Push, 而保留在自己本机, 或者Push到U盘等其它备份的地方, 熟悉git的话这是很自然的事.


还剩下些
============

Octopress的文档中github相关都是使用git命令行, 上述的操作在Push时使用的是TortoiseGit,  使用Git for Windows操作github上的代码库以后另起一篇来说.

这些是根据昨天的操作回忆而写的, 所以可能有疏漏和记忆偏差.

Octopress的模版, 评论, 还有其它扩展可以Google, 以后用到也许会写些文章.

Octopress自身的东西在<http://octopress.org/docs/>上很全.

我没学过ruby, 上面提及ruby相关的地方很可能概念有错.