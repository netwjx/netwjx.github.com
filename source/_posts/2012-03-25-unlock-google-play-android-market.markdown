---
layout: post
title: "Google Play/Android Market 解锁"
date: 2012-03-25 22:09
comments: true
categories: Android
---

Android Market刚改名叫Google Play不久,不明白为什么改成这个名字,难道Play后面还有Game?

说说标题上的事,如果使用浏览器查找应用,应用是免费的,但是安装哪里会提示"此商品无法在您设备所在的国家/地区安装".

在Google帐号设置里面怎么改都没作用.

而用手机搜索,要么搜不到,要么搜到了点安装仍旧是上面的提示.

上面提示的依据只依据一个 **手机卡的网络运营商**.

搜到一些解决办法是使用Market Enabler,但是我尝试的结果是没作用,应该是升级到了Google Play以前的方法失效了.

<!--more -->

继续搜索发现了[Market Unlocker](https://play.google.com/store/apps/details?id=com.evanhe.marketunlocker) ,使用后发现可用,下面基本是Market Unlocker的中文使用说明.


Market Unlocker
---------------------------

这个软件只能让手机可以安装哪些限制特定地区安装的软件,比如[Inotia 3](https://play.google.com/store/apps/details?id=com.com2us.inotia3.normal.freefull.google.global.android.common) ,不可能免费安装收费的软件.

这个软件需要手机已经root, 或者是可以获取到root权限(我这使用小米手机会在获取root权限时提示).

需要wifi,并开飞行模式.

开始.

[下载地址](https://play.google.com/store/apps/details?id=com.evanhe.marketunlocker) , 或在手机上搜 Market Unlocker , 开发者是Evan He的那个 , 免费版的即可.

切换到飞行模式

安装好后会看到应用**市场解锁**,打开后**主页**中打开**启用解锁**,这将会有一系列的提示,如果没root这里将会失败.

可以在**市场**里面选择模拟的运营商,默认是Verizon.

退出,到系统设置 - 程序 - 程序管理 - 全部,找到**Google Play 商店**,进去后**清除数据**.

重启手机.

打开Wifi,在开飞行模式的情况下.

等待Google服务同步完成或刷新Gmail.(这段是Market Unlocker的说明,我不记得我有这步操作)

打开Google Play,查找需要安装的软件并安装.

最后关闭飞行模式.


吐槽
--------------------------------

免费的应用也设置地区限制,这是什么逻辑嘛.即使是收费的,地区限制也完全没必要,只要能支付就行了.

况且上面的限制完全没有发挥任何作用,只是折腾人,或者使用其它的应用市场.


对艾诺迪亚 3(Inotia 3)的吐槽
--------------------------------

这个游戏在480x854的解析度上看起来画面不精细,可能是我习惯了NDS哪种2D游戏的像素感了.

这个游戏不提供多点触控支持,即使设备支持,结果就是控制移动的时候点技能没效果,而点技能没放开的话也不能移动.再加上下面的原因会很让人觉得这设计真坑人.

人物的卡位,在场景中移动,遇到阻挡会自动向旁边划开,但是在战斗时前面有队友或者敌人挡住会被*粘住*,不大容易做到擦身而过,人物占位空间比实际看到的稍微大一点.

再加上战斗时队友不会自动让路,自动让路也仅仅支持相邻的2个,前面再挡一个自己的队友就卡住了.

还有一些队友AI的毛病,繁琐的物品和队伍界面.

总感觉玩起来不那么顺畅,熟悉了能在中间环节上快点,但是还是感觉繁琐.

上述这些可能是因为要兼容旧版本做的一些妥协吧.