---
layout: post
title: "Javascript异步加载"
date: 2012-11-04 17:50
comments: true
categories: Javascript
---

这是8月份写了一份草稿, 但是一直都觉得这个主题组织起来比较纠结, 现在觉得不该再拖了, 先把之前的理解都整理出来吧.

异步加载这个名称不是很贴切, 实际上有三部分, 非阻塞(不暂停页面渲染) 下载 执行. 只是叫异步加载字数少点, 请不要完全从这个字面理解其意义.

主要用于外链的js文件, 会带来下面的好处:

-   页面内容显示更快, 特别对于定义在`<head>`和文档开始处的外链js.
-   使用第三方Javascript时, 如果第三方无法访问, 也不会使页面很长时间是空白.
-   使用一些手法可以控制页面内容的显示顺序, 比如重要的先显示.
-   模块化Javascript, 使用[Javascript模块加载器](#jsloader)管理大量相互依赖的Javascript.

如果仅仅想页面内容显示的更快, 可以简单的把脚本放置在文档结尾, 比如`</body>`标签前.

异步加载的js文件有一个限制的:

-   不能使用`document.write()`, 因为页面已经加载完成, 再调用会覆盖现有页面的内容.

下面是异步加载的一些实现方式.


使用script标签的defer属性
-------------------------

``` html
<script type="text/javascript" defer src="javascript.js"></script>
```

使用了`defer`属性的`<script>`标签下载时不会暂停页面渲染, 当页面解析完后执行, 即常说的`DOM Ready`之后, `window load`之前.

如果有多个`<script defer>`将会按照DOM中的顺序执行, 多个前后依赖的脚本可以放心使用.

<!-- more -->

`defer`属性在html 4中就定义了, 各浏览器兼容性如下:

-   Chrome, Safari支持.
-   Firefox 3.5开始支持, 从3.6开始对行内脚本忽略`defer`属性, 将会立即执行.
-   IE 4开始支持, 对于行内脚本的`defer`属性IE6会有一些特殊的规则.
-   Opera 不支持.

行内脚本(inline script)是指相对于使用`src`属性外链的脚本来说的, 即下面的代码:

``` html
<script type="text/javascript">
    alert('inline script');
</script>
```

IE6中外链脚本的`defer`属性符合上文描述的规则, 但是行内脚本遵循下面的规则.

-   `<head>`中定义的会在`<head>`标签解析完成执行.
-   `<body>`中定义的会在`<body>`标签解析完成执行.


使用script标签的async属性
-------------------------

``` html
<script type="text/javascript" async src="javascript.js"></script>
```

使用了`async`属性的脚本下载时同样不会暂停页面渲染, 但是它会在下载完成时就执行, 在多个外链脚本时, 可能会有无法控制的执行顺序, 前后依赖的多个脚本不能使用这种方式加载.

`async`属性在html 5中定义, 各浏览器兼容性如下:

-   Chrome, Safari支持.
-   Firefox 3.6开始支持.
-   IE 10开始支持.
-   Opera不支持.

### async和defer的异同

-   同样都可以在下载时不暂停页面渲染.
-   下载完`async`会立即执行, 而`defer`会在页面解析完按照DOM树中的顺序执行.

如果浏览器支持的话, `async`的优先级比`defer`高, 即如果`async`为`true`的话, 会忽略`defer`属性.


使用Javascript编码方式
----------------------

上述拥有`defer` `async`属性的`<script>`标签都可以通过Javascript编码方式插入到DOM树中, 代码如下:

``` html
<script type="text/javascript">
(function(){
    var node = document.createElement('script');
    node.type = 'text/javascript';
    node.async = true; // 使用async, 请根据实际需要修改
    node.defer = true; // 使用defer, 请根据实际需要修改
    node.src = 'javascript.js';
    document.getElementsByTagName('head')[0].appendChild(node);
}());
</script>
```

上述代码适合放到`<body>`中, 因为`<head>`标签未解析完成的情况下不能插入元素.

也可以在页面加载后(`window.onload`)插入, 代码如下:

``` html
<script type="text/javascript">
(function(w, d){
    if (w.addEventListener) {
        w.addEventListener('load', onLoad, false);
    } else if (w.attachEvent) {
        w.attachEvent('onload', onLoad);
    } else {
        w.onload = onLoad;
    }

    function onLoad(){
        var node = d.createElement('script');
        node.type = 'text/javascript';
        node.src = 'javascript.js';
        d.body.appendChild(node);
    }
}(window, document));
</script>
```

更常用的是`DOM Ready`之后插入, 相对会更早点, 鉴于完整的`DOM Ready`代码量比较多, 下面例子使用jQuery的`DOM Ready`实现:

``` html
<script type="text/javascript">
jQuery(function($){
    var file = 'javascript.js';
    $('<script type="text/javascript">').attr('src', file).appendTo('head');
});
</script>
```

Javascript编码方式也是[Javascript模块加载器](#jsloader)基本原理.


<a name="jsloader"></a>
使用Javascript模块加载器
------------------------

这是更重量级的做法, 适用于大量互相依赖的Javascript的异步加载, 一般需要遵循模块加载器的规则编写自己的模块以用于异步加载.

下面是常见Javascript模块加载器和简单的使用代码.

### RequireJS

[RequireJS](http://requirejs.org/)

``` html
<head>
<script data-main="scripts/main" src="scripts/require.js"></script>
<!-- RequireJS加载完成后会加载 scripts/main.js, 其内容见下面的代码 -->
</head>
```

``` js scripts/main.js
require(["helper/util"], function(util) {
    // 这个函数会在 scripts/helper/util.js 加载后调用.
    // 参数 util 是 helper/util 模块, 其包括 helper/util.js 中使用 define() 定义的值和函数.
});
```

### Head JS

[Head JS](http://headjs.com/) 除了提供加载js之外还可以加载css, css js和浏览器特性检测等. 这里只贴加载js的示例代码.

``` html
<script type="text/javascript">
head.js("/path/to/jquery.js", "/google/analytics.js", "/js/site.js", function() {
   // all done
});
</script>
```

### SeaJS

[SeaJS](http://seajs.org) 是 [lifesinger](https://github.com/lifesinger) 发起的项目, 提供有完整的中文文档和相关预编译, 打包部署工具. 并且其模块化API遵循[CommonJS][CommonJS]的标准.

``` html
<script src="assets/sea-modules/seajs/1.3.0/sea.js"></script>
<script type="text/javascript">
// 加载入口模块
seajs.use('./assets/src/hello.js');
</script>
```

``` js /assets/src/hello.js
define(function(require) {
  // 得到 Spinning 函数类
  var Spinning = require('./spinning');

  // 初始化
  var s = new Spinning('#container');
  s.render();
})
```

使用spm打包部署

```
$ cd hello-seajs/assets
$ spm build 
...
BUILD SUCCESS!
$
```

作为第三方提供嵌入代码的建议
----------------------------

如果打算让别的网站通过一段代码来嵌入自己网站的内容, 建议提供下面这种风格的嵌入代码.

``` html
<div id="widget"></div>
<script type="text/javascript" defer async
    src="http://domain.com/widgets/username/?appendTo=widget">
</script>
```

-   `id="widget"` 是用于放置第三方组件的容器.
-   `script` 定义了 `defer` `async` 用于异步加载, 不会暂停页面渲染.
-   `src` 属性的URL定义了用户相关的数据(`/username`), 以及指定把组件添加到`id="widget"`的标签中.

其Javascript大概是这样的

``` js
var ele = document.getElementById('widget'),
    html = [];

html.push('<a href="http://domain.com/username">username</a>');
// ...
ele.innerHTML = html.join('');
```

延迟解析Javascript
------------------

在参考资料中 [Defer parsing of JavaScript][DeferParsingJS] 提及在移动应用中一般会减少使用外链脚本的数量, 这样可能行内脚本会增多, 对于哪些不是必须立即执行的行内脚本可以尝试的延迟解析, 不仅仅是延迟执行.

具体做法比如将其写为注释或任何能让浏览器忽略的格式, 等需要的时候再使用`eval()`执行.

当然也可以简单的将所有`<script>`放在文档结尾.

参考资料
--------

-   [script的defer和async 携程UED](http://ued.ctrip.com/blog/?p=3121)
-   [script - HTML | MDN](https://developer.mozilla.org/en-US/docs/HTML/Element/Script)
-   [CommonJS][CommonJS]
-   [Prefer asynchronous resources - Make the Web Faster - Google Developers](https://developers.google.com/speed/docs/best-practices/rtt#PreferAsyncResources)
-   [Defer loading of JavaScript - Make the Web Faster - Google Developers](https://developers.google.com/speed/docs/best-practices/payload#DeferLoadingJS)
-   [Defer parsing of JavaScript - Make the Web Faster - Google Developers][DeferParsingJS]

[DeferParsingJS]: https://developers.google.com/speed/docs/best-practices/mobile#DeferParsingJS "Defer parsing of JavaScript"
[CommonJS]: http://www.commonjs.org/ "CommonJS"