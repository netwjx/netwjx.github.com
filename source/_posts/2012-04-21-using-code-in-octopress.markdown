---
layout: post
title: "在Octopress中使用代码高亮"
date: 2012-04-21 16:45
comments: true
categories: [Octopress, Jekyll]
---

在[Octopress][]中使用代码高亮, 实际就是[Jekyll][]的[Pygments][]代码高亮, 效果如下

源

	``` js Javascript Hello World 
		alert('hello world');
	```
效果

``` js Javascript Hello World 
	alert('hello world');
```

而默认安装[Octopress][]时对代码高亮还是不支持的, 还需要安装[Python][], 我没有使用[ActivePython][], 而是[CPython][], 安装好后应该会有`c:\Windows\System32\python27.dll`.

但是现在还可能会出现`Could not open library’.dll’`的问题.

<!-- more -->

下面的修改会和版本有关, 我目前使用的Octopress版本是`2.0 2012/3/8 Commit:9f40242b1e7eb0098f0ef3c508c7bed7e647b982`

将`Gemfile.lock`的**33行**

	pygments.rb (0.1.3)

修改为

	pygments.rb (0.2.11)

以及**40行**

	rubypython (0.5.1)

修改为

	rubypython (0.5.3)

注意上面的修改不要改变原有的缩进, 然后在命令行下执行

	bundle install

这将会使用[bundler][]这个依赖管理工具安装新版本的[pygments.rb][]和[rubypython][].

如果还有问题请参考[Windows 8安装Octopress记录](http://hivan.me/octopress-install-to-windows8/)的**部署Python**部分.

[octopress]: http://octopress.org
[jekyll]: http://jekyllrb.com/
[pygments]: http://pygments.org/
[python]: http://python.org/
[activepython]: http://www.activestate.com/activepython
[cpython]: http://python.org/getit/
[bundler]: http://gembundler.com/
[pygments.rb]: https://github.com/tmm1/pygments.rb/
[rubypython]: http://rubypython.rubyforge.org/


Octopress代码高亮的工作原理
---------------------------

如果上面的还是不能使用代码高亮就需要了解原理之后在自行判断如何处理.

[Octopress][]的代码高亮实际是[Jekyll][]的代码高亮, 其中插件`Backtick Code Blocks` `Code Blocks` `Include Code` 这些插件都有代码高亮功能, 其代码高亮都使用`Pygments Code`插件, 这个插件如名字所示, 其使用的gem库是[pygments.rb][].

[pygments.rb][]包含有[pygments][]的代码, 可以在Ruby安装目录下的`\lib\ruby\gems\1.9.1\gems\pygments.rb-0.2.11\vendor`中看到.

使用[bundler][]安装[pygments.rb][]时会自动的安装它依赖的[rubypython][].

[pygments.rb][]使用[rubypython][]的方式为[ffi][], 这个是ruby中调用C语言写的库的工具, 在这里是调用`python27.dll`.

[ffi]: https://github.com/ffi/ffi



备用方案
--------

上述的方法还是不能正常使用代码高亮的话, 还可以使用一些后备的方法.


### Gist插件

在[github:gist](https://gist.github.com/)上贴代码, 并使用类似下面的代码

	{{ "{% gist 2436351" }} %}

将展示为

{% gist 2436351 %}

[Gist Tag 插件的更多资料](http://octopress.org/docs/plugins/gist-tag/)


### jsFiddle插件

这个更适合用于web前端相关的html css js的展示, 使用类似下面的代码

	{{ "{% jsfiddle 3h5A4/3" }} %}

将展示为

{% jsfiddle 3h5A4/3 %}

[jsFiddle Tag 插件的更多资料](http://octopress.org/docs/plugins/jsfiddle-tag/)

