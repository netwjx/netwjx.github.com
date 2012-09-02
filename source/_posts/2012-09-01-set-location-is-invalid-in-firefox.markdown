---
layout: post
title: "在Firefox下设置location不生效"
date: 2012-09-01 21:17
comments: true
published: false
categories: Javascript Firefox Error Memo
---

之前发现了一个很奇怪的现象, 在使用了iframe的页面中, 调用`location='xxxxx'`的代码没有生效, 具体重现方式见下面, 测试的Firefox版本是15.0 稳定版.



加了`try`语句发现抛出了异常, 但是这个异常没有在Firebug中出现, Firefox的错误控制台也没有发现这个错误信息.

尝试改成`location.href='xxxxx'`结果发生了另外一个错误.


在MDN上关于[location的文档](https://developer.mozilla.org/en-US/docs/DOM/window.location)中翻看, 发现Firefox提供有`assign()` `replace()`作为替代的重定向方式, `replace`不会在后退中留下历史, 替换为`assign('xxxxxx')`就可以正常了.


查看IE的DOM文档发现也有提供`assign()` `replace()`.

之后又尝试使用`setTimeout`方式调用也可以正常.


具体这个现象如何解释我也说不清, 只能说从一个`window`中的代码调用另外一个`window`中的代码时, 对另外一个`window.location`的访问和普通的访问有所不同.