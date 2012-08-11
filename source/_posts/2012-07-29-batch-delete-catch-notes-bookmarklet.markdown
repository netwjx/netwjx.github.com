---
layout: post
title: "批量删除Catch.com笔记的小工具"
date: 2012-07-29 18:12
comments: true
categories: Javascript Bookmarklet
---

目前手机上使用[Catch][]来记录和收集手机上看到的各种信息, 在电脑上查看之后会删除, 但是奇怪的是[Catch.com][Catch]网站的**My Ideas**不显示删除按钮, 而别的都会显示, 但是在手机上收集的信息默认不选择的时候都会保存到**My Ideas**分类里面, 所以就有了下面这个工具.


<a href="javascript:(function(d, l) {if (!/https:\/\/catch\.com\/m/.test(l.href)) {alert(&#39;only in https://catch.com/m/ is work !&#39;);return;}var notes = d.querySelectorAll(&#39;[class$=-notelist] div[id&#94;=full-]&#39;);for (var i = 0; i < notes.length; i++) {var chk = notes[i].querySelector(&#39;input[type=checkbox]&#39;);if (chk.checked) {notes[i].querySelector(&#39;input[value=delete]&#39;).click();}}}(document, location));">Catch.com批量删除当前选中的笔记</a>

这是一个Bookmarklet, 使用方式是在上面这个链接上鼠标右键

-   IE **添加到收藏夹**, 使用了querySelector, 所以需要IE8及更高版本才支持.
-   Firefox **将此链接加为书签**
-   Chrome 按**Ctrl + Shift + B**显示书签栏后把链接拖到书签栏上

然后访问[Catch.com][Catch], 登录后点**My Ideas**, 先找个笔记点删除, 默认会弹出确认删除, 选中**Do not show me this message again** -> **Delete**.

然后依次选中想删除的笔记, 在收藏夹(IE)/书签菜单(Firefox)/书签栏(Chrome)中点刚刚保存的书签, 就可以看到笔记被一个个的删除.

<!-- more -->

上述Bookmarklet的源码是

``` js bookmarklet.js Catch.com批量删除当前选中的笔记
(function(d, l) {
    if (!/https:\/\/catch\.com\/m/.test(l.href)) {
        alert('only in https://catch.com/m/ is work !');
        return;
    }
    var notes = d.querySelectorAll('div[class$=-notelist] div[id^=full-]');
    for (var i = 0; i < notes.length; i++) {
        var chk = notes[i].querySelector('input[type=checkbox]');
        if (chk.checked) {
            notes[i].querySelector('input[value=delete]').click();
        }
    }
}(document, location));
```

这里有一篇关于Bookmarklet和编写的资料, [Bookmarklet编写指南](http://www.ruanyifeng.com/blog/2011/06/a_guide_for_writing_bookmarklet.html).

一个简单的在线Bookmarklet编写网页, [Bookmarklet Crunchinator](http://ted.mielczarek.org/code/mozilla/bookmarklet.html).

[Catch]: https://catch.com/
