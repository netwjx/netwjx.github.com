---
layout: post
title: "在jQuery中发生'Object' 未定义"
date: 2012-04-15 13:09
comments: true
categories: [Javascript, IE9]
---

之前发现一个比较奇怪的现象, 一个很典型的页面, 总是在打开时会在jQuery中的一个位置发生 `'Object' 未定义` 的错误, 并且只在首次打开, 编译需要时间, 加载也比平时慢点的情况下.

在不使用jQuery的页面也发生类似现象, 错误可能是window未定义, document未定义之类的.

仅ie9下有这个现象, 忽略这个错误后仍能正常打开页面, 没有任何功能有问题.

记得以前遇到过类似的现象, 这次仔细找了下发现了这个:

[IE9 throws exceptions when loading scripts in iframe. Why?](http://stackoverflow.com/questions/8389261/ie9-throws-exceptions-when-loading-scripts-in-iframe-why)

以及msdn的 [APIs Are Not Available if iFrame Is Removed from DOM Tree](http://msdn.microsoft.com/en-us/library/gg622929%28v=VS.85%29.aspx?ppud=4)

简单的说是在包含iframe的页面中, 如果这个iframe被移除后, 其内部的Javascript和DOM API都会无法被调用.

上述**特性**在ie9标准下有效, 往后更新的版本应该也是如此.

上面只是根本原因, 实际会有一些比较复杂的表现方式, 比如在jQuery中类似 `$('#id').appendTo('#foo')` 的代码将会先从DOM树中移除, 然后再添加进去, 这将会诱发上述现象.

其它的比如jQuery EasyUI的Layout, 它的实现方式会修改DOM结构, 这将会移除和重新创建包含iframe的元素.


处理办法
--------

简单的可以是避免在IE9标准模式渲染.

麻烦点的就是先不设置iframe的src, 等移除iframe操作完成后再设置, 一般可以考虑在window.onload时做这个操作.

可以利用setTimeout让一些操作在事件触发完毕后再执行, 关于setTimeout的特性可以参考[How JavaScript Timers Work](http://ejohn.org/blog/how-javascript-timers-work/)
