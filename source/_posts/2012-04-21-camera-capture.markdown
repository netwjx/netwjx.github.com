---
layout: post
title: "捕获摄像头信息"
date: 2012-04-21 14:59
comments: true
categories: [Win32API, DirectShow, VLC, MF, CSharp]
---

最近有做一个从摄像头获取信息的程序, 期间查找了各种方案, 这里列出一些总结.


实现方案
--------

1.  avicap32.dll 的实现 Win32API
    
    主要使用`capGetDriverDescriptionA`函数获取获取摄像头设备, 使用`capCreateCaptureWindow`和`SendMessage`发送一系列窗口消息控制, 图像数据使用一个`PictrueBox`控件来显示, 有可以保存到avi文件.

    其属于**Video for Windows**技术, 代码示例可以参考[How to Interface to a Video Device and Capture Video and Images][avicap32_1], C#的代码示例可以参考[_VideoCapturer.cs][avicap32_2], 以及MSDN上的参考[Video Capture ][avicap32_3]

    这个实现方法无法使用**虚拟摄像头**, `capGetDriverDescriptionA`不会返回任何虚拟摄像头设备.

[avicap32_1]: http://kadaitcha.cx/vb/capture_webcam_video.html
[avicap32_2]: http://www.koders.com/csharp/fidFEFD079826A1CB5ACB35A56EC33C4651456FA0A7.aspx
[avicap32_3]: http://msdn.microsoft.com/en-us/library/windows/desktop/dd757692.aspx

1.  DirectShow 的实现

    这个实现的API使用起来比上面的要繁杂很多, 但是可以使用**虚拟摄像头**, 现在典型的IM软件其实现应该都是基于此.

    没找到什么入门的介绍,只能从MSDN上[DirectShow][dShow_1]翻看

    可以先从[Introduction to DirectShow Application Programming][dShow_2]了解典型的结构和流程, `Filter Graph Manager`是核心的部分, 以及 [DirectShow System Overview][dShow_3], 结构图:

    ![High level architecture][dShow_img]

    DirectShow 视频捕获部分[Video Capture][dShow_4]

    在dotnet下有一个[DirectShow.Net][dShowNet_1]库对DirectShow的封装, 可以直接在C#和VB.Net中直接使用, 文档仍旧需要以DirectShow的文档为主, 但是DirectShow.Net提供有大量的[代码示例][dShowNet_2], 个别有些小问题, 但是简单改改都可以正常跑起来.

[dShow_1]: http://msdn.microsoft.com/en-us/library/dd375454.aspx
[dShow_2]: http://msdn.microsoft.com/en-us/library/dd390352.aspx
[dShow_3]: http://msdn.microsoft.com/en-us/library/dd375470.aspx
[dShow_img]: http://i.msdn.microsoft.com/dynimg/IC420381.png
[dShow_4]: http://msdn.microsoft.com/en-us/library/dd407331.aspx

[dShowNet_1]: http://directshownet.sourceforge.net/index.html
[dShowNet_2]: http://sourceforge.net/projects/directshownet/files/DirectShowSamples/

1.  libVLC 的实现, 源自VLC播放器

    [VLC][]是跨平台的影音播放器, 除了能播放传统视频外, 还可以捕获视频, [具体的特性][vlc_1]中有描述, 可以看到Windows下**Video acquisition**的实现是基于DirectShow

    而[libVLC][vlc_2]是VLC播放器的底层库

    ![Technical Diagram][vlc_img]

    在dotnet下有一个[VLC][]的封装[vlcdotnet][vlc_3], 也是开源的, 从介绍上可以看到能在WinForm, WPF, SilverLight 5下使用, 需要依赖**libvlc.dll**, **libvlccore.dll**, 安装[VLC][]播放器后在安装目录下能找到.

[vlc]: http://www.videolan.org/vlc/
[vlc_1]: http://www.videolan.org/vlc/features.html
[vlc_2]: http://www.videolan.org/vlc/libvlc.html
[vlc_img]: http://images1.videolan.org/images/libvlc_stack.png
[vlc_3]: http://vlcdotnet.codeplex.com/

1.  Microsoft Media Foundation 的实现

    [MMF][] 这个其实没什么好讲的, 主要是只有Windows Vista及以后的才支持, 说是用来代替DirectShow的, 文档仍旧是以C++为主的, 在未来也许会比较有价值.

[mmf]: http://msdn.microsoft.com/en-us/library/windows/desktop/ms694197.aspx


综述
----

1.  最简单的是avicap32的实现.

1.  需要支持虚拟摄像头, 或者是方便使用虚拟摄像头调试, 可以使用基于DirectShow的方案.

1.  需要跨平台, 或者是涉及到音视频回放之类的可以使用基于VLC的方案.

1.  MMF暂时周边相关的还不是很成熟, 除非环境允许能够使用这个方案.

我最后选择的使用DirectShow, 使用[DirectShow.Net][dShowNet_1]库, 代码麻烦了点, 但是有示例还是问题不大.

