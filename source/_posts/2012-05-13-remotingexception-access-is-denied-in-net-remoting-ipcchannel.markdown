---
layout: post
title: "使用.Net Remoting的IpcChannel时发生 RemotingException : 拒绝访问 异常"
date: 2012-05-13 22:09
comments: true
published: false
categories: CSharp IPC Remoting
---

在一个使用IPC进行单机跨进称的通讯时发生了上述的异常, 期间查找异常原因的时候发现中文不大容易搜到正确的答案, 也可能是因为Remoting是已经不再支持的技术吧, 但是因为目前还有很多时候不能使用WCF, 所以这里将这个异常的原因和解决办法介绍一下.