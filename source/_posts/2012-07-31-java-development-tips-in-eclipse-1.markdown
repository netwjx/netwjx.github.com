---
layout: post
title: "在Eclipse中的Java开发技巧(1)"
date: 2012-07-31 21:12
comments: true
categories: Eclipse Java Tips
---

这是我以前使用Eclipse时经常使用的一些小技巧, 多数都是比较基础的, 涉及的方面也比较的多. 觉得比较实用, 就整理成文.

不分先后顺序, 只是想到什么就写什么, 因为内容比较多, 所以这篇是1.

以英文版的介绍为主, 因为我发现很多人基本都只使用英文版.


快速测试简短代码
----------------

不是很熟悉字符串的查找, 截取等到底返回的是多少? 不清楚日期返回的年月日分别是几? 不清楚某个静态方法给特定值返回的是多少?

这些经常会遇到的小问题, 基本都可以建立一个测试Java项目写个包含main的静态方法, 在里面写测试代码就行了. 但是这样始终很麻烦. 可以试试下面的这个功能:

先确保右上已经选择的是 **Java**(Java perspective), 在随便一个Java项目中右键 -> **New** -> **Other**, 选择树状结构中的**Java -> Java Run/Debug -> Scrapbook Page**, 如下图

![ScrapBook](/i/e/scrapbook.png)

然后**Next**, 输入文件名, 比如`test`, **Finish**. 打开的窗口中可以输入类似下面的代码, 选择所有代码后点工具栏上的**Display Result of Evaluating Selected Text**, 如下图:

![ScrapBook](/i/e/scrapbook-1.png)

鼠标右键菜单中也有和菜单栏按钮等价的菜单项:

![ScrapBook](/i/e/scrapbook-2.png)

-   Inspect

    可以在弹出的小窗口中显示, 类似Eclipse中调试Java代码时的Inspect
-   Display

    上文已经说过了, 它可以将这段表达式或最后一行语句的结果显示在编辑器中

-   Execute

    这个和直接运行差不多, `System.out.println`这些会输出

-   Set Imports

    设置默认导入哪些类, 包, 类似Java中`import`语句
