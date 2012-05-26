---
layout: post
title: "WinForms开发中SynchronizationContext和Invoke的使用注意事项"
date: 2012-04-29 14:26
comments: true
categories: Dotnet Thread
---

WinForms 开发中[Control.Invoke][]是用于非UI线程中请求修改UI元素的方法, 一般配合[Control.InvokeRequired][]使用:

``` csharp Control.Invoke and Control.InvokeRequired
public partial class Form1 : Form
{
    private void Foo(string text)
    {
        if (InvokeRequired)
        {
            Invoke((Action<string>)Foo, text);
        }
        else
        {
            textBox1.Text = text;
        }
    }
}
```

类似[Control.Invoke][]的还有[Control.BeginInvoke][]和[Control.EndInvoke][], 它们是异步调用.

这些方法和属性都依赖于[IsHandleCreated][]为`true`时, [IsHandleCreated][]表示窗口句柄是否已创建, 它并不是指是否`new Form1()`过, 而是指是否`Show()`过, 包括[Application.Run][], [Show][], [ShowDialog][]这些调用都会使[IsHandleCreated][]为`true`.

而在[IsHandleCreated][]为`false`时, 比如刚刚`new Form1()`, [Control.InvokeRequired][]返回`false`, 调用[Control.Invoke][]会抛出异常:

    System.InvalidOperationException: 在创建窗口句柄之前，不能在控件上调用 Invoke 或 BeginInvoke。

<!-- more -->

当在非UI线程和多个窗口之间操作时, 可能会有一些麻烦的情况发生, 这种情况可能会考虑使用[SynchronizationContext][].

[SynchronizationContext][]可以在当前线程第一次`new Form1()`之后通过[SynchronizationContext.Current][]取得, 之后使用[Post][]和[Send][]实现在UI线程执行指定的委托, 下面使用的[WindowsFormsSynchronizationContext][].Current在WinForms程序中等价于[SynchronizationContext.Current][]:

``` csharp SynchronizationContext.Post
public partial class Form1 : Form
{
    public static SynchronizationContext SyncContext { get; set; }

    public Form1()
    {
        InitializeComponent();
        SyncContext = WindowsFormsSynchronizationContext.Current;
    }

    private void Foo(string text)
    {
    	SyncContext.Post(delegate(object obj)
		{
			textBox1.Text = text;
		}, null);
    }
}
```

从[SynchronizationContext.Current][]的文档可知它只会返回当前线程的同步上下文, 要在别的线程中访问需要自行保存它的引用, 即这里属性`SyncContext`, 使用时确保在访问`SyncContext`之前`new Form1()`过一次, 且只能一次, 否则后续的会覆盖之前的, 在符合需求的情况下会很自然想到单例模式:

``` csharp 线程安全的单例模式
	static Form1[] _Instance = { null };

	public static Form1 Instance
	{
	    get
	    {
	        if (_Instance[0] == null)
	        {
	            lock (_Instance)
	            {
	                if (_Instance[0] == null)
	                {
	                    _Instance[0] = new Form1();
	                }
	            }
	        }
	        return _Instance[0];
	    }
	}
```

目前看起来是没什么问题了, 现实总是会出点问题, 比如[SynchronizationContext.Current][]总是返回当前线程的, 结合上述的单例模式, 如果第一次访问`Instance`属性是在别的线程中, 测试代码如下:

``` csharp 在不同的线程中访问Form1.Instance
	new Thread(delegate()
	{
	    Form1.Instance.ToString();
	    Debug.Assert(SynchronizationContext.Current != null);
	}).Start();

	Thread.Sleep(3000);

	var f = Form1.Instance;
	Debug.Assert(SynchronizationContext.Current == null);
	Application.Run(f);
```

上面代码的两处断言都通过了, 这种情况下[Form1.SyncContext.Post][Post]仍旧可以调用, 但是将**不产生任何效果**, 也**不抛出异常**, 因为`new Form1()`的那个线程已经结束了, 以及那个线程并没有执行消息循环[Application.Run][].

如果需要在[Application.Run][]之后, 相关的UI元素变得可用时再执行相关代码, 可以自行定义事件, 实现相关的触发和绑定, 确保`new Form1`和[Application.Run][]在同一个线程中调用, 在具体的多线程环境中解决办法会表现的完全不同.



[SynchronizationContext]: http://msdn.microsoft.com/zh-cn/library/system.threading.synchronizationcontext.aspx
[Control.Invoke]: http://msdn.microsoft.com/zh-cn/library/zyzhdc6b.aspx
[Control.BeginInvoke]: http://msdn.microsoft.com/zh-cn/library/0b1bf3y3.aspx
[Control.EndInvoke]: http://msdn.microsoft.com/zh-cn/library/system.windows.forms.control.endinvoke.aspx
[Control.InvokeRequired]: http://msdn.microsoft.com/zh-cn/library/system.windows.forms.control.invokerequired.aspx
[IsHandleCreated]: http://msdn.microsoft.com/zh-cn/library/system.windows.forms.control.ishandlecreated.aspx
[SynchronizationContext.Current]: http://msdn.microsoft.com/zh-cn/library/system.threading.synchronizationcontext.current.aspx
[Post]: http://msdn.microsoft.com/zh-cn/library/system.threading.synchronizationcontext.post.aspx
[Send]: http://msdn.microsoft.com/zh-cn/library/system.threading.synchronizationcontext.send.aspx
[WindowsFormsSynchronizationContext]: http://msdn.microsoft.com/zh-cn/library/system.windows.forms.windowsformssynchronizationcontext.aspx
[Application.Run]: http://msdn.microsoft.com/zh-cn/library/ms157902.aspx
[Show]: http://msdn.microsoft.com/zh-cn/library/system.windows.forms.control.show.aspx
[ShowDialog]: http://msdn.microsoft.com/zh-cn/library/c7ykbedk.aspx


