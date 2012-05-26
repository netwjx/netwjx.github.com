---
layout: post
title: "截取指定字节长度的字符串"
date: 2012-04-15 18:35
comments: true
categories: Java
---

在搜文本换行算法的时候发现了[编写一个截取字符串的函数](http://www.iteye.com/topic/1037773), 问题是

> 编写一个截取字符串的函数，输入为一个**字符串**和**字节数**，输出为**按字节截取的字符串**。
> 
> 但是要保证汉字**不被截半个**，如“我ABC”4，应该截为“我AB”，输入“我ABC汉DEF”，6，应该输出为“我ABC”而不是“我ABC+汉的半个”。

<!--more -->

可能描述的有些不明确, 应该这样说

> 编写一个截取字符串的函数, 给定**字符串**, **编码格式**, 使用前2个参数编码之后的**字节数组**, 以及截取**字节数组的最大长度**.
> 
> 要求返回**实际需要截取的长度**, 不能在解码指定长度字节数组后出现**半个字符**的现象.

那么测试代码大概是这样的(就以Java为例):

``` java
  String str = "我abc的def";
  String charset = "gbk";
  int length = 6;
  byte[] bytes = str.getBytes(charset);

  String result = new String(bytes, 0, subString(str, charset, bytes,
      length), charset);
  assert result.equals("我abc的");
```

最后一行的断言仅适用于gbk和utf-8的情况, 其它的不保证可用.

在开始的帖子中看到过一个实现, 等价于下面的代码:

``` java
  private static int subString(String str, String charset, byte[] bytes,
      int length) throws UnsupportedEncodingException {
    int i = 0;
    for (char c : str.toCharArray()) {
      int n = i + String.valueOf(c).getBytes(charset).length;
      if (n > length)
        return i;
      else if (n == length)
        return n;
      i = n;
    }
    return i;
  }
```

不过想想, subString返回值一般在length-3到length之间, 可以探测截取指定长度是否会有问题, 那么就可以有下面的一个实现:

``` java
  private static int detectByte(String str, String charset, byte[] bytes,
      int length) throws UnsupportedEncodingException {
    String s = null;
    int i = length + 1;
    do {
      i--;
      s = new String(bytes, 0, i, charset);
    } while (!str.substring(0, s.length()).equals(s));
    return i;
  }
```

再想想, 实际有差别的只是最后一个字符, 只比较最后一个字符即可:

``` java
  private static int subString(String str, String charset, byte[] bytes,
      int length) throws UnsupportedEncodingException {
    String s = null;
    int n = length + 1;
    int i;
    do {
      n--;
      s = new String(bytes, 0, n, charset);
      i = s.length() - 1;
    } while (str.charAt(i) != s.charAt(i));
    return n;
  }
```

第一种会比较慢些, 后面的方法会占用更多的内存.

这个问题始终和编码类型有关的, 因为需要返回的是字节数组/流的长度, 而不是字符数组/串/流的长度.

不过这个代码的应用场景我还是想不出来, 即使有这样的场景, 也可以有别的变通办法可以不需要这样截取.
