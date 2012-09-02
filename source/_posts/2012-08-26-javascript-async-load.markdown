---
layout: post
title: "Javascript的异步加载"
date: 2012-08-26 20:27
comments: true
published: false
categories: Javascript Async
---

典型的HTML页面加载时, 必须把script标签指定的js下载并执行完才能继续显示后面的内容, 多少js都是自己的服务器还好, 但是如果外链的js下载速度太慢的话, 就会发生页面很长一段时间全白的现象. 这种情况使用js的异步加载技术则能很明显的提高页面打开速度.

其基本原理是

用js异步加载js的简单实现

使用script标签的属性控制异步加载

defer和差异async



现阶段简单的实现代码如下


如果是更多的js, 包含依赖关系的, 就应该考虑使用js加载器了.


现有的js加载器
--------------

现在多少的js加载器都能够实现异步加载, 比如RequireJS

Head JS

国内如seajs


关于第三方js组件异步加载的想法
------------------------------

多数第三方的js都是`document.write()`这种方式显示组件的, 这种的就没办法异步加载.