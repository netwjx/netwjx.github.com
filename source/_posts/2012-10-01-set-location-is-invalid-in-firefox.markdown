---
layout: post
title: "在Firefox下设置location不生效"
date: 2012-10-01 16:26
comments: true
categories: Javascript jQuery Firefox Error Memo
---

项目中使用的窗口组件加载内容是使用`iframe`实现的, 以前遇到的各种问题总是在IE下, 但是之前又发现一个很奇怪的问题, 仅在Firefox下出现.

具体表现为窗口组件关闭时再将相关的父级或`iframe`重定向到新的地址, 结果在Firefox下没看到重定向, 也没在错误控制台看到任何错误信息.

前提: 以下所有的都不涉及跨域的问题, 只描述Firefox下运行的情况, 目前我的Firefox版本是15.0.1.

关键结构如下, `$`表示jQuery:

``` html
<script>
    function dialog()
        var ifrm = $('<iframe id="Dialog1">').appendTo('body')[0];
        ifrm.openWindow = window;
        // ...

    function dialogClose(frameElement, url)
        $(frameElement).remove();
        (frameElement.openWindow || window).location = url;
</script>

<iframe id="main">
    <button onclick="parent.dialog()">打开</button>

<!-- 打开窗口时 -->
<iframe id="Dialog1">
    <button onclick="parent.dialogClose(frameElement, 'other.html')">关闭并重定向 #main 的地址</button>
```

一些需要说明的实际情况

-   窗口是指顶级页面的`window`和`iframe`中的`window`. 窗口下是指`window.document`和下面的所有DOM元素.
-   在`#main`中`parent.dialog()`实际是自动探测或指定在哪个父级打开窗口.
    -   在`Dialog1`中`parent.dialogClose`实际是哪个窗口打开就重定向那个窗口, 或者指定重定向哪个窗口.
-   `<iframe id="Dialog1">` 是按照实际打开的情况自动分配的id, 这里使用固定的id方便说明.


上述代码运行后的结果没有产生重定向, 加了`try catch`后:

    An error occurred throwing an exception

出错行在 `(frameElement.openWindow || window).location = url;`.

<!-- more -->

怀疑可能是不能识别默认属性, 换成`location.href`试试

    "Component returned failure code: 0x804b000a (NS_ERROR_MALFORMED_URI) [nsIDOMLocation.href]"

在[MDN window.location](https://developer.mozilla.org/en-US/docs/DOM/window.location#Methods)发现有`assign`和`replace`也可以用来重定向

`assign`正常执行了, 但是`replace`

    "Component returned failure code: 0x804b000a (NS_ERROR_MALFORMED_URI) [nsIDOMLocation.replace]"

想到可能和上下文有关吧, 试试用目标`window.setTimeout`, 传入字符串参数, 执行正常了.

``` js
    (frameElement.openWindow || window).setTimeout('location="' + url + '"', 0)
```

上述所有尝试的代码示例:

{% jsfiddle sLDmC/69 default default 510px %}

-   所有`iframe`加载的页面都在这一个里面, 根据不同的Url Query执行不同的代码.
-   `openWindow.`表示重定向的是按钮所在窗口.
-   水平分割线下面的是重定向当前窗口.
-   蓝线以下是一些输出的信息, 以及发生异常时的异常信息.
-   重定向成功会显示一个红色背景的成功, 发生异常会在日志中显示出来.
-   重定向成功后, **Result**标签页右边有个**Run again**可以恢复开始状态.


另一方面
--------

虽然问题算是解决了, 但是为什么在哪种情况会发生异常, 仅在Firefox下. 还有没有其它可以回避这个异常的方式.

想想上面代码有些怪怪的就是, 先从DOM树中移除了`iframe`, 如果想办法调整一下移除和重定向的顺序, 就有了下面的示例:

{% jsfiddle sLDmC/68 default default 510px %}

可以看到所有的重定向都成功了.


总结
----

-   尽量避免使用`iframe`.
-   尽量使用一种方式进行跨`iframe`间的调用, 比如setTimeout方式.
    -   调用参数尽量用基本类型, 比如字符串, 数字, 复杂的可以用JSON格式字符串.
-   尽量规避从DOM树移除当前`iframe`后还需要执行代码的情况.
    -   实在无法规避就需要十分注意前后的执行顺序.

当然如果和我一样是维护原有项目, 有很多地方不能随便修改, 遇到麻烦就只能大量摸索了. 比如上文中的尝试.


附:使用location的assign()和replace()的注意点
--------------------------------------------

在`iframe`中`location.assign()`必须确保当前`iframe`已加载一个页面, 不然会发生错误

    "Component returned failure code: 0x804b000a (NS_ERROR_MALFORMED_URI) [nsIDOMLocation.assign]"

对于已加载页面的则正常, 例子:

{% jsfiddle gQvmx/13 default default 370px %}
