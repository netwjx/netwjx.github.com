---
layout: post
title: "使用.Net Remoting的IpcChannel时发生 RemotingException : 拒绝访问 异常"
date: 2012-06-03 12:09
comments: true
categories: CSharp IPC Remoting Windows
---

在一个使用IPC进行单机跨进称的通讯时发生了 `RemotingException : 拒绝访问` 异常, 期间查找异常原因的时候发现中文不大容易搜到正确的答案, 也可能是因为Remoting是已经不再支持的技术吧, 因为历史的原因还不能使用WCF, 所以这里将这个异常的原因和解决办法介绍一下.

发生这个异常的场景是一个Windows服务程序在IPC信道注册, 另外一个桌面程序连接到IPC信道通讯, 重点是在IPC信道注册的程序是Windows服务, 默认情况下它将运行在LocalSystem帐号下, 连接这个IPC信道的是另外的用户启动的进程.

错误的原因是向IPC信道注册时, 默认的授权是相同用户的进程才可以访问这个IPC信道, 可以通过下面的代码修改默认授权:

<!-- more -->

``` csharp
var dict = new Dictionary<string, string>();
dict["name"] = dict["portName"] = portName;
dict["authorizedGroup"] = "Everyone";
serverChannel = new IpcServerChannel(dict, null);
ChannelServices.RegisterChannel(serverChannel, false);
```

其中`portName`变量是IPC信道的名称

在IIS中运行的Web应用一般也是由一个`IUSER_xxxxx`的用户运行, 所以还有通过`web.config`配置方式在IPC信道注册的方式:

``` xml
<?xml version="1.0"?>  
<configuration>  
 <system.runtime.remoting>  
   <application>  
     <client>  
       <wellknown type="fragrank.FragRankRemoting,FragRankLogic" url="ipc://FragRankChannel/FragRank" />  
     </client>  
     <channels>  
       <channel ref="ipc" authorizedGroup="Everyone">  
         <clientProviders>  
          <formatter ref="binary"/>  
         </clientProviders>  
       </channel>  
     </channels>  
   </application>  
 </system.runtime.remoting>  
</configuration>
```


参考资料
--------

-   [Calling a Windows Service from ASP.NET via Remoting & IpcChannel](http://www.codedblog.com/2007/09/01/calling-a-windows-service-from-aspnet-via-remoting-ipcchannel/)

    MSDN的文档对属性值并没有太多的说明, 这个里面有多个示例.

-   [信道属性](http://msdn.microsoft.com/zh-cn/library/bb397847.aspx)

-   [服务器信道属性](http://msdn.microsoft.com/zh-cn/library/bb397831.aspx)

