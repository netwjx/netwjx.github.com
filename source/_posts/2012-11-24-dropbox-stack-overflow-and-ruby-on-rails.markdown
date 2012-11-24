---
layout: post
title: "Dropbox, Stack Overflow 和 Ruby on Rails 杂念"
date: 2012-11-24 21:08
comments: true
categories: 
---

它们有什么联系? 其实没什么特别的联系, 所以是杂念, 没什么头绪, 就是那么想到, 我一个个说来.

Dropbox的故事
-------------

[Dropbox](http://dropbox.com/)很出名的网盘服务, 也可以叫它云端存储服务, 它的客户端能够自动同步多个电脑间的文件夹, 当然这个功能在现在十分常见了, 只是在他出现之前, 多数网盘服务都是以Web形式为主的. 它给免费用户提供2G空间, 通过邀请其它用户可以扩容空间, 如果还不够可以付费拥有更多的空间.

还有其它很多细节, 想了解的可以自己使用看看, 这里就提提这种按服务收费的方式. Dropbox已经被河蟹认证, 访问会立即连接被重置, 不过这不影响接下来的一些事.

[Y Combinator](ycombinator.com)是一家很有意思的风险投资公司, 它只向最早期的创业团队投资. 而Dropbox是它最成功的投资之一.

Paul Grahm是Y Combinator的创始人, 被誉为**硅谷创业之父**, 他曾经从事过程序员的工作. [阮一峰][阮一峰]的网络日志[我要翻译Paul Graham了](http://www.ruanyifeng.com/blog/2009/12/i_will_translate_paul_graham.html) 上面介绍的很不错, 引用首段:

{% blockquote %}
他1964年出生于英国，在康奈尔大学读完本科，然后在哈佛大学获得计算机科学博士学位。1995年，他创办了Viaweb，帮助个人用户在网上开店，这是世界上第一个互联网应用程序。1998年夏天，Yahoo!公司收购了Viaweb，收购价约为5000万美元。

此后，他架起了个人网站paulgraham.com，在上面撰写了许许多多关于软件和创业的文章，以深刻的见解和清晰的表达而著称，迅速引起了轰动。2005年，他身体力行，创建了风险投资公司Y Combinator，将自己的理论转化为实践，目前已经资助了80多家创业公司。现在，他是公认的互联网创业权威。
{% endblockquote %}

这就引出了Paul Grahm的一本书, [黑客与画家 Hackers and Painters: Big Ideas from the Computer Age][黑客与画家], 注意英文副标题, 可以直译为**计算机时代的伟大想法**. 这本书译者是上面提到的[阮一峰的网络日志][阮一峰]的博主[阮一峰][阮一峰].

仍旧以Dropbox来结束Dropbox的故事吧, [为什么 Dropbox 比其它同类产品更受欢迎?](http://www.syncoo.com/why-dropbox-is-more-popular-than-similar-tools.htm) 作者是[Syncplicity](http://www.syncplicity.com/)的联合创始人, 难道是酸葡萄心理? 当然不是, 为了逻辑的完整性, 建议点击哪个问题的链接进去看看, 原因有很多. 对照[黑客与画家][黑客与画家]中的一些篇幅能明显感觉到有Paul Grahm所持的一些观点.

这是Dropbox的故事.

[黑客与画家]: http://book.douban.com/subject/6021440/
[阮一峰]: http://www.ruanyifeng.com/blog/


Stack Overflow的故事
--------------------

[Stack Overflow](http://stackoverflow.com/)是一个免费的问答网站, 很类似国内的百度知道, 只是他有浓郁的Geek, 技术人员文化, Stack Overflow在程序中是堆栈溢出错误, 这是一种很棘手, 不很容易处理的错误, Stack Overflow还有相关的其它领域的一系列问答网站, 如体育, 各种外语, 电影电视, 个人理财等.

对我来说, 我日常工作中Google搜索问题时, 能在Stack Overflow上得到十分有价值的答案, 甚至将工作分为[有Stack Overflow前和有了Stack Overflow之后](http://heikezhi.com/2011/05/12/does-stackoverflow-make-us-lazy/).

这些都来自[Stack Exchange][Stack Exchange]公司, 这些网站上全都没有广告, 也没有向用户收费的服务, Stack Exchange也募集到了风险投资, 不过这里要说的是在哪之前.

[Joel Spolsky][Joel Spolsky]是[Stack Exchange的联合创始人](http://stackexchange.com/about/team), 点击链接可以进去看到[Stack Exchange][Stack Exchange]团队很多人的GIF动画, 他同时也是[Fog Creek][Fog Creek]的创始人, Fog Creek有一些不错的团队协作工具:

-   [Trello](https://trello.com/)
    在线协作工具, 在一个界面上组织多个项目, 实时沟通, 分派任务等.
-   [FogBugz](http://www.fogcreek.com/fogbugz/)
    Bug跟踪工具, 在线申请立即开通, 可以和第三方工具和服务集成.
-   [Kiln](http://www.fogcreek.com/kiln/)
    分布式版本控制系统(基于[Mercurial](http://mercurial.selenic.com/)), 代码审查工具, 仍然是在线申请开通, 可以和FogBugz集成.
-   [Copilot](https://www.copilot.com/)
    提供在线技术支持, 主要是修正电脑使用中的一些问题.

除了Trello是免费的外(无广告), 其它的都是免费试用 + 按服务收费, 在线服务方式, 即SaaS.

[Joel Spolsky]的个人Blog名字叫Joel on Software, 他将自己Blog上的一些文章整理到一起, 出了本书叫[More Joel on Software](http://www.amazon.com/More-Joel-Software-Occasionally-Developers/dp/1430209879), 国内有出中文翻译[软件随想录](http://www.ruanyifeng.com/mjos/), 译者还是上文提到的[阮一峰](http://www.ruanyifeng.com/blog/2008/10/i_will_translate_more_joel_on_software.html), [点击这里](http://www.ruanyifeng.com/mjos/)进去可以看到部分篇章, 会发现里面讨论了软件开发中很多有趣的话题.

这里引用一下对[Joel Spolsky][Joel Spolsky]的介绍:

{% blockquote %}
Joel Spolsky（乔尔•斯波尔斯基）是一个世界闻名的软件开发流程专家。

他的网站“Joel谈软件”在全世界程序员中非常流行，被译成了30多种语言。

作为纽约的Fog Creek Software公司的创始人，他开发了FogBugz软件，这是一个在软件开发团队中非常流行的项目管理系统。

Joel曾经在微软公司工作，是Excel开发团队的一员，他设计了VBA（Excel的宏语言）。他还曾在Juno Online Services公司工作，开发了几百万用户使用的互联网客户端。
{% endblockquote %}

这是Stack Overflow的故事.

[Joel Spolsky]: http://www.joelonsoftware.com/
[Stack Exchange]: http://stackexchange.com/
[Fog Creek]: http://www.fogcreek.com/


Ruby on Rails的故事
-------------------

Ruby on Rails
37signals
geting real



3个有趣的人 3本书
-----------------

他们不止写了上文提到的哪些书, 只是我接触了上述哪些, 可能是哪些书比较有名吧.

我不支持个人崇拜, 除了上面这些人, 他们的团队及相关的人中也有很多值得去了解的, 关注谈论的话题是更有趣的事.

这是一篇杂念, 上述的人和事对自己有些启发, 但又说不上来具体什么, 但是有一种想把各种线索都理清的冲动, 所以有了上述文字.



插队 Github的故事
-------------------

github是我很喜欢的一个代码托管服务, 除了提供软件开发所需要的东西外, 他还强调了很多社会化方面的东西, 这个在使用之后就能感觉到.


附
----

团队协作工具还有很多, 可以参考[Eclipse MyLyn Task Repository Connectors](http://wiki.eclipse.org/index.php/Mylyn/Extensions#Task_Repository_Connectors)列表中列出的.
