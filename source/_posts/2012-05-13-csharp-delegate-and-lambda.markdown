---
layout: post
title: "C#委托和Lambda表达式"
date: 2012-05-19 19:54
comments: true
categories: CSharp Functional Delegate Lambda
---

C#算是个多范式编程语言, 除了传统的OO风格, 还可以在部分范围中使用函数式编程的风格, 这里整理一下C#中委托和Lambda实践中的各种写法. 

这里不会解释具体的代码含义, 仅仅介绍写法, 可能不适合刚开始学习.


声明委托类型
------------

使用前必须要有具体的委托类型, 下面的例子中会使用到这些常用的委托类型

``` csharp
    delegate void Action();

    delegate void Action<in T1, in T2>(T1 arg1, T2 arg2);

    delegate bool Predicate<in T>(T obj);

    delegate TResult Func<in T1, in T2, out TResult>(T1 arg1, T2 arg2);
```

`Action`和`Action<in T1, in T2>`是在dotnet 3.5 sp1出现的一个很实用的委托, 类似的还有1-16个参数的, 这里主要使用这2种.

`Predicate`是从dotnet 2.0就出现的, 一般是在泛型集合的查询中使用.

`Func<in T1, in T2, out TResult>`也是dotnet 3.5 sp1出现的, 和`Action`基本一样, 也有1-16个参数的, 和Action不同的是这个委托都声明有返回值类型, 而不是`Action`的void.

<!-- more -->

最初的写法
--------------

最简单的`Action`

``` csharp
    static void Main(string[] args)
    {
        Action foo = new Action(Foo);
    }
    
    static void Foo()
    {
        // ...
    }
```

对于复杂的委托, 比如`Func`

``` csharp
    static void Main(string[] args)
    {
        Func<int, string, bool> foo = new Func<int, string, bool>(Foo);
    }

    static bool Foo(int i, string s)
    {
        // ...
    }
```

匿名委托
--------

和上一个区别就是不需要创建`Foo`方法了

``` csharp
    Action foo = new Action(delegate()
    {
        // ...
    });
```

`Predicate`就是这样的

``` csharp
    Predicate<string> foo = new Predicate<string>(delegate(string s)
    {
        return false;
    });
```

右边的`new xxxx()` 可以省略

``` csharp
    Action<int, string> foo = delegate(int i, string s)
    {
        // ...
    };
```

由于也是一行代码, 结尾的分号还是必须的.

也适用于**最初的写法**

``` csharp
    static void Main(string[] args)
    {
        Func<int, string, bool> foo = Foo;
    }

    static bool Foo(int i, string s)
    {
        // ...
    }
```

如果使用的是dotnet 4的编译器, 可以使用`var`, 看起来就像是颠倒过来了

``` csharp
    var foo = new Func<int, string, bool>(delegate(int i, string s)
    {
        return false;
    });
```

`var`是编译器提供的**魔法**, 会自动推导`=`右边的类型, 当然前提是右边的可以推导出来类型, 无法推导出来就会编译错误.


Lambda登场
----------

``` csharp
    Action foo = () => Console.WriteLine("hello, world");

    Action<int, string> foo = (i, s) => Console.WriteLine(i + s);
    
    Predicate<string> foo = s => s.startsWith("bar");
    
    Func<int, string, bool> foo = (i, s) => s.Length < i;
```

语法方面, 无参数要写成`()`, 1个参数可以省略括号, 2个及更多参数则必须括号`()`; `=>` 右边必须有表达式; 表达式结果必须是委托的返回值类型, 如果委托返回值类型是void则无所谓表达式结果类型.

Lambda也算是编译器魔法, 上述Lambda表达式特点都是左边的委托类型明确, 即委托的参数, 返回值也是明确的, 和`var`相似, 类型是可推导出来的, 那么就可以使用Lambda, 这样就省了写一堆的参数类型和return语句.

实际使用中可能是这样的

``` csharp
    List<string> list = new List<string>();
    // ...

    list.FindAll(s => s.startsWith("bar"));
```

即除了声明变量, 参数是明确的委托类型时, 也可以使用Lambda.

Lambda的`=>`右边也可以是多行代码

``` csharp
    Func<int, string, bool> foo = (i, s) =>
    {
        return false;
    };

    ThreadPool.QueueUserWorkItem(o =>
    {
        // ...
    });
```

委托可以叠加
------------

``` csharp
    Action foo;
    // ...
    foo += ()=> Console.WriteLine("bar");

    Func<int, string, bool> foo
    // ...
    foo += (i, s) => s.Length < i;
```

执行时会按照先加先执行的顺序, 如果有返回值, 那么将使用最后加进来的委托的返回值.

同样也可以从叠加的里面减去, 不过这里是按引用, 所以需要保留一个加进去的委托引用.

``` csharp
    Action foo;
    // ...
    Action bar = () => Console.WriteLine("foo");
    foo+=bar;
    // ...
    foo-=bar;
```

### 事件

C#提供了一个`event`关键字用于声明一种特殊的委托, 可以在类外部`+=` `-=`, 但是执行委托只能在内部

``` csharp
    event EventHandle Foo;

    void Bar()
    {
        Foo += (o, e) = Console.WriteLine("Foo Event");
    }

    void Bar2()
    {
        Foo(new object(), EventArgs.Empty);
    }
```

默认的事件实现中`+=` `-=`是线程安全的, 这点可以在反编译`event`的源码中看到, 如果要自行实现`event`的`+=` `-=`则需要自行处理线程安全.


总结
----

使用委托可以避免创建太多的中间方法, 而使用Lambda, 则可以使在写委托的时候避免大量的`delegate`关键字和重复的委托参数类型声明.

也许会让代码不是很容易理解, 但是只要遵循一些约定, 熟悉了还是没关系的.

重要的是这会少写很多重复的东西, 同样修改时也少修改一些东西.


参考链接
--------

-   [C# 语言规范 1.10 委托](http://msdn.microsoft.com/zh-cn/library/aa664629%28v=vs.71%29)
-   [委托（C# 编程指南）](http://msdn.microsoft.com/zh-cn/library/ms173171%28v=vs.80%29.aspx)
-   [委托（C# 参考）](http://msdn.microsoft.com/zh-cn/library/900fyy8e%28v=vs.80%29.aspx)
-   [C# 关键字](http://msdn.microsoft.com/zh-cn/library/x53a06bb%28v=vs.80%29.aspx)
-   [Lambda 表达式（C# 编程指南）](http://msdn.microsoft.com/zh-cn/library/bb397687.aspx)
-   [Predicate<T> Delegate](http://msdn.microsoft.com/en-us/library/bfcke1bz)
-   [Action<T1, T2> Delegate](http://msdn.microsoft.com/en-us/library/bb549311)
-   [Action Delegate](http://msdn.microsoft.com/en-us/library/system.action)
-   [Func<T1, T2, TResult> Delegate](http://msdn.microsoft.com/en-us/library/bb534647)
