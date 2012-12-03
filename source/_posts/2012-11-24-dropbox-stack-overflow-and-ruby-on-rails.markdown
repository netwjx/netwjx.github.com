---
layout: post
title: "Dropbox, Stack Overflow 和 Ruby on Rails 杂念"
date: 2012-11-24 21:08
comments: true
categories: Memo IT Saas Book
---

它们有什么联系? 其实没什么特别的联系, 所以是杂念, 没什么头绪, 就是想到了, 我一个个说来.


Dropbox的故事
-------------

[Dropbox][]是很出名的网盘服务, 也可以叫它云端存储服务, 它的客户端能够自动同步多个电脑间的文件夹, 当然这个功能在现在十分常见了, 只是在他出现之前, 多数网盘服务都是以Web形式为主的. 它给免费用户提供2G空间, 通过邀请其它用户可以扩容空间, 基本上后来的网盘都是这种套路. 额外还有根据订购的套餐按月付费.

[Y Combinator][YC]是一家很有意思的风险投资公司, 它只向最早期的创业团队投资. 而[Dropbox][]是它最成功的投资之一.

{% img right http://www.ruanyifeng.com/images/hnp_cover_b.jpg 318 Hackers and Painters %}

[Y Combinator][YC]的创始人是[Paul Grahm][Paul], 被誉为[硅谷创业之父](http://www.programmer.com.cn/11408/), 他曾经从事过程序员的工作. [阮一峰的网络日志][阮一峰] [我要翻译Paul Graham了](http://www.ruanyifeng.com/blog/2009/12/i_will_translate_paul_graham.html)上面介绍的很不错, 引用首段:


{% blockquote 阮一峰 http://www.ruanyifeng.com/blog/2009/12/i_will_translate_paul_graham.html 我要翻译Paul Graham了 %}
下面，我就告诉你，我为什么那么想翻译Paul Graham。

他1964年出生于英国，在康奈尔大学读完本科，然后在哈佛大学获得计算机科学博士学位。1995年，他创办了Viaweb，帮助个人用户在网上开店，这是世界上第一个互联网应用程序。1998年夏天，Yahoo!公司收购了Viaweb，收购价约为5000万美元。

此后，他架起了个人网站paulgraham.com，在上面撰写了许许多多关于软件和创业的文章，以深刻的见解和清晰的表达而著称，迅速引起了轰动。2005年，他身体力行，创建了风险投资公司Y Combinator，将自己的理论转化为实践，目前已经资助了80多家创业公司。现在，他是公认的互联网创业权威。
{% endblockquote %}


这就引出了[Paul Grahm][Paul]写的书[Hackers and Painters: Big Ideas from the Computer Age][hackpaint], 注意英文副标题, 可以直译为**计算机时代的伟大想法**. 这本书的中译版是[黑客与画家][], 译者是上面提到的[阮一峰][].

这里有一个有趣的故事, [为什么 Dropbox 比其它同类产品更受欢迎?](http://www.syncoo.com/why-dropbox-is-more-popular-than-similar-tools.htm) 有趣的在于其中回答这个问题的人中有[Dropbox][]的竞争产品 - [Syncplicity][]的联合创始人, 其中不乏他的多年思考总结, 以及一些行业的内幕轶事.

这是[Dropbox][]的故事.

[YC]: http://ycombinator.com/
[Dropbox]: http://dropbox.com/
[Paul]: http://www.paulgraham.com/
[hackpaint]: http://www.amazon.com/exec/obidos/tg/detail/-/0596006624
[黑客与画家]: http://www.ruanyifeng.com/docs/pg/
[阮一峰]: http://www.ruanyifeng.com/blog/
[Syncplicity]: http://www.syncplicity.com/

<!-- more -->


Stack Overflow的故事
--------------------

[Stack Overflow][]是一个免费的问答网站, 很类似国内的[百度知道](http://zhidao.baidu.com/), 不过它有浓郁的Geek和技术文化, `Stack Overflow`在程序中是堆栈溢出错误, 这是软件开发工作中一种很棘手, 很不容易处理的严重错误, [Stack Overflow][]还有相关的其它领域的一系列问答网站, 如体育, 各种外语, 电影电视, 个人理财等.

对我来说, 我日常工作中Google搜索问题时, 能在[Stack Overflow][]上得到十分有价值的答案, 甚至可以将工作分为[有Stack Overflow前和有了Stack Overflow之后](http://heikezhi.com/2011/05/12/does-stackoverflow-make-us-lazy/).

[Stack Overflow][]属于[Stack Exchange][]公司的产品, [Stack Exchange][]下的一系列问答网站全都没有广告, 也没有向用户收费的服务, [Stack Exchange][]也获得了风险投资, 不过这里要说的是在哪之前.

[Joel Spolsky][]是[Stack Exchange的联合创始人](http://stackexchange.com/about/team), 可以看到[Stack Exchange][]团队很多人耍宝的GIF动画, [Joel Spolsky][]同时也是[Fog Creek][]的创始人, [Fog Creek][]有一些不错的团队协作产品:

-   [Trello][]  在线协作工具, 在一个界面上组织多个项目, 实时沟通, 分派任务等.
-   [FogBugz][]  Bug跟踪工具, 在线申请立即开通, 可以和第三方工具和服务集成.
-   [Kiln](http://www.fogcreek.com/kiln/)  分布式版本控制系统(基于[Mercurial](http://mercurial.selenic.com/)), 代码审查工具, 仍然是在线申请开通, 可以和FogBugz集成.
-   [Copilot](https://www.copilot.com/)  提供在线技术支持, 主要是修正电脑使用中的一些问题.


除了[Trello][]是免费的外(无广告), 其它的都是免费试用 + 根据套餐按月付费, 提供基于Web和移动平台的客户端.

{% img right http://i260.photobucket.com/albums/ii7/ruanyf/blog/bg2009120201.jpg 318 软件随想录 %}

[Joel Spolsky][]的个人Blog名字叫[Joel on Software][Joel Spolsky], 他将自己Blog上的一些文章整理到一起, 出了本书叫[More Joel on Software](http://www.amazon.com/More-Joel-Software-Occasionally-Developers/dp/1430209879), 国内有出中文翻译[软件随想录](http://www.ruanyifeng.com/mjos/), 译者还是上文提到的[阮一峰][], [点击这里](http://www.ruanyifeng.com/mjos/)进去可以看到部分篇章, 里面讨论了软件开发中很多有趣的话题.

这里引用一段[Joel Spolsky][]的介绍:


{% blockquote 阮一峰 http://www.ruanyifeng.com/blog/2008/10/i_will_translate_more_joel_on_software.html 我要翻译《Joel on Software》了！ %}
Joel Spolsky（乔尔•斯波尔斯基）是一个世界闻名的软件开发流程专家。

他的网站“Joel谈软件”在全世界程序员中非常流行，被译成了30多种语言。

作为纽约的Fog Creek Software公司的创始人，他开发了FogBugz软件，这是一个在软件开发团队中非常流行的项目管理系统。

Joel曾经在微软公司工作，是Excel开发团队的一员，他设计了VBA（Excel的宏语言）。他还曾在Juno Online Services公司工作，开发了几百万用户使用的互联网客户端。

他已经出版了三本书：User Interface Design for Programmers（《程序员之用户界面设计》，Apress, 2001），《Joel谈软件》（Joel on Software, Apress, 2004），以及Smart and Gets Things Done（《巧妙完成工作》，Apress, 2007）。

他还是The Best Software Writing I（《最佳软件文选（第一辑）》，Apress, 2005）的编辑。

Joel从耶鲁大学获得计算机科学本科学位。

他曾在以色列国防军（Israeli Defense Forces）中服伞兵役，并且是以色列哈纳顿集体农场（Kibbutz Hanaton）的共同创始人之一。
{% endblockquote %}


这是[Stack Overflow][]的故事.

[Trello]: https://trello.com/
[FogBugz]: http://www.fogcreek.com/fogbugz/
[Stack Overflow]: http://stackoverflow.com/
[Joel Spolsky]: http://www.joelonsoftware.com/
[Stack Exchange]: http://stackexchange.com/
[Fog Creek]: http://www.fogcreek.com/


Ruby on Rails的故事
-------------------

[Ruby on Rails][]是我在做Java工程师时接触到的, 感叹它巧妙的设计, 在当时给Java世界带来了巨大的震撼, 原来Web应用也可以这样开发! 时至今日, [Ruby on Rails][]依然是[Ruby][]社区中的明星项目.

在之后的多年中我还陆续接触过[Groovy][] [Django][] [web2py][] [Apache Play][] [ASP.Net MVC][], 它们或多或少都能看到[Ruby on Rails][]的影子.

{% img right http://37signals.com/images/front-cover.png 318 REWORK: The new business book from 37signals. %}

[Ruby on Rails][]的作者是[David Heinemeier Hansson][David], 以下是他自己的简介, 我简单翻译成中文:


{% blockquote David Heinemeier Hansson http://david.heinemeierhansson.com/ David Heinemeier Hansson %}
我是Ruby on Rails的作者, 37signals的合伙人, 纽约时报(NYT)畅销书作家, 公开演说家, 业余摄影师, 和赛车手.
{% endblockquote %}


这里畅销书指的是[Rework][], 除了[纽约时报(NYT)](http://www.nytimes.com/)外还有[华尔街日报(WSJ)](http://wsj.com/)和[The Sunday Times](http://www.thesundaytimes.co.uk/), 由[Jason Fried][Jason]和[David Heinemeier Hansson][David]合著, 封面是个揉了的纸团, 豆瓣网有[Rework](http://book.douban.com/subject/5320866/)的中文简介.

还有一本[Getting Real][], 副标题是: 小规模，更快速，更高质量的软件构建方法, 翻译引用自[CNBorn](http://cnborn.net/docs/getting_real/index.html). 这是一本更多讲软件开发, 非技术方面的东西.

上面这两本书都可以**免费**从作者网站上下载的, 但是它们的实体书同样销售的不错, 也确实, 这种书需要反复的来回看, 领悟.

[37signals][]这家公司同样很有意思, 他们有几个在线协作产品:

-   [Basecamp](http://basecamp.com/)  项目管理工具, 跟踪项目的讨论, 相关文件, 事件.
-   [Highrise](http://highrisehq.com/)  简单的CRM系统, 保存整理便笺和Email会话, 跟踪客户反馈和交易, 在公司 部门 团队中共享信息.
-   [Campfire](http://campfirenow.com/)  实时沟通, 类似IM, 但是专门设计用于小组.

这些产品都是基于Web, 以及提供移动平台客户端, 并根据套餐按月付费.

他们有与众不同的内部工作方式, [为什么我要把公司做成扁平型](http://www.aqee.net/jason-fried-why-i-run-a-flat-company/), 作者是[37signals][]的创始人[Jason Fried][Jason].

在[关于](http://37signals.com/about)还可以看到[Jeff Bezos][Jeff], 他是作为[37signals][]的顾问, 当然他更出名的是作为[亚马逊 Amazon.com](http://www.amazon.com/)的创始人和CEO.

这是[Ruby on Rails][]的故事.

[Ruby on Rails]: http://rubyonrails.org/
[Ruby]: http://www.ruby-lang.org/en/
[Groovy]: http://groovy.codehaus.org/
[Django]: http://www.djangoproject.com/
[web2py]: http://www.web2py.com/
[Apache Play]: http://www.playframework.org/
[ASP.Net MVC]: http://www.asp.net/mvc
[David]: http://david.heinemeierhansson.com/
[Jason]: http://37signals.com/svn/writers/jf
[Getting Real]: http://gettingreal.37signals.com/
[Rework]: http://37signals.com/rework
[37signals]: http://37signals.com/
[Jeff]: http://en.wikipedia.org/wiki/Jeff_Bezos


末尾
----

上面提到的网站和产品多数是英文的, 还有受限于我国的网络问题而无法访问.

上面提及的书基本都不涉及技术细节, 都很适合IT从业者反复阅读, 而[Rework][]更是适合各种人群阅读.

即使未来不打算从事创业, 但是也很有助于辨别优秀的创业者, 合作方, 投资目标, 抑或是改善自己的日常工作

我仍旧无法用概括性的文字来描述我为什么要写上面的文字, 暂且作为对一些有趣资料的介绍吧.