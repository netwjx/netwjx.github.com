---
layout: post
title: "在Eclipse中的Java开发技巧(2)"
date: 2012-08-12 12:46
comments: true
categories: Eclipse Java Tips
---

这是这个系列的第2篇, 还是十分简单的技巧.


调试时的ScrapBook
-----------------

上篇介绍到了ScrapBook, 在断点调试时也有类似的功能.

![Display](/i/e/display.png)

通过**Window** -> **Show View** -> **Other**, 在**Show View**窗口顶部的文本框输入`Display`, 应该会在下面看到**Display**, 点击即可打开上图所示界面.

具体功能和上篇的ScrapBook基本一致, 只是用于调试时, 这个主要是可以在调试时, 把一些变量的值直接以文本方式展示, 甚至可以自己填些说明, 方便后续的调试参考.

<!-- more -->


快速找到当前文件在项目中的位置
------------------------------

经常会需要查看当前编辑的文件在项目文件系统中的路径, 标签上只显示了文件名, 鼠标移上去可以看到路径, 但是如果想查看同目录下其它的文件就比较麻烦了. 下面是个快速找到当前文件在项目中位置的方式.

![Link With Editor](/i/e/link-with-editor.png)

因为点了**Link With Editor**后, 切换编辑的文件将总会自动转到对应的项目路径, 所以一般我会点两次恢复默认.


快速在临近的类和方法中跳转
--------------------------

上一段说的是针对所有文件都能生效的方法, 但是对于Java类来说, 想知道它在项目中的路径, 挺多时候实际目的是查看和它临近类, 那么可以使用**Breadcrumb**.

![Breadcrumb](/i/e/breadcrumb.png)


两种不同风格的包浏览结构
------------------------

在项目上可以显示两种不同的Java包结构, 通过点击**Package Explorer**或**Project Explorer**窗口右上的**View Menu** -> **Package Presentation** -> **Flat**或**Hierarchical**在两种风格中切换, 实际效果如图:

![Package Presentation](/i/e/package-presentation.png)