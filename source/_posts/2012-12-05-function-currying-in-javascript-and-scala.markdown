---
layout: post
title: "函数的Currying (Javascript 和 Scala)"
date: 2012-12-05 13:52
comments: true
categories: Javascript Scala Memo
---

Currying或者Curry, 中文有翻译成[科里化][]. 我最早了解它是在一篇讲[Groovy中函数式编程][Groovy Curry]的文章中, 之后又在[Python][]中[遇到同样的东西][Python Curry]. 最近在看[Scala][]的介绍时[又看到了][Scala Curry], 而且发现[Scala][]设计的明显更好, 然后就成了这篇文章, 使用Javascript作为主要语言是因为我使用Javascript的时间更长, 并且Javascript这门语言的表达能力[奇强](http://www.nafine.com/Work_View.php?id=271)&#94;-&#94;.


Currying是[函数式编程][跨越边界: JavaScript 语言特性]中一种[高阶函数][wiki 高阶函数]的典型应用, 如果非要把它对应到传统OO中的话, 那么它类似[Builder模式](https://www.google.com/search?q=builder+pattern), 一般译作构建器模式 建造者模式. 

Builder模式可以简单理解为创建一个复杂的对象需要依赖多个参数, 要提供的参数又依赖于不同的方法, 使用Builder模式让每个方法只关注自己提供的参数, 最终根据全部参数创建出对象来. 对象实例最终是拿来调用的, 你可以把这个过程想象成调用一个参数很多的函数.

Javascript中完全可以按照传统OO的方式实现Builder模式, 但使用Currying更轻量级 简单, 考虑下面的代码:

``` js
function filter(list, func) {
    var ret = [];
    for (var i = 0; i < list.length; i++) {
        var v = list[i];
        if (func(v)) {
            ret.push(v);
        }
    }
    return ret;
}

function modN(n, x) {
    return x % n === 0;
}

var nums = [1, 2, 3, 4, 5, 6, 7, 8];

console.log(filter(nums, function(x) {
    return modN(2, x);
}));

console.log(filter(nums, function(x) {
    return modN(3, x);
}));
```

<!-- more -->

执行输出

```
2,4,6,8
3,6
```

modN函数有2个参数, 示例中可以同时提供所有的参数, 当然这是相当理想的情况. 实际可能不同的参数在不同的阶段提供:

``` js
var p = [2];  // 提供相关参数
console.log(filter(nums, function(x) {
    p[1] = x;
    return modN.apply(this, p);
}));

p[0] = 3;  // 提供相关参数
console.log(filter(nums, function(x) {
    p[1] = x
    return modN.apply(this, p);
}));
```

这种方式需要有一个变量用来保存参数, 而如果使用Currying可以这样:

``` js
console.log(filter(nums, modN.curry(2)));
console.log(filter(nums, modN.curry(3)));
```

根据需要可以`curry()`多个参数或`curry()`多次. 上文中使用的`curry`函数的实现:

``` js
Function.prototype.curry = function() {
    var func = this,
        p = Array.prototype.slice.call(arguments, 0);
    return function() {
        return func.apply(this, p.concat.apply(p, arguments));
    };
};
```

这是最轻量级 最简单的实现方式, 深入挖掘Javascript语言的表达力应该还会出现更巧妙的设计.


Currying的来由
--------------

考虑体积计算公式`体积 = 长 x 宽 x 高`, 假设已知长为10, 那么这个公式就变成了`体积 = 10 x 宽 x 高`, 进一步已知宽为7, 那么公式就变为`体积 = 10 x 7 x 高`, 这种转换即Currying.

这是最通俗的描述, 比较正式的可以参考[维基百科][]的[Currying][wiki Currying]词条.


Scala语言中的Currying
---------------------

之所以要额外提[Scala][], 是因为它是原生支持Currying的语言, 相对比通过类库支持能提供更巧妙的语法, 参见下面的代码:

``` scala A Tour of Scala: Currying http://www.scala-lang.org/node/135 来源
object CurryTest extends Application {

  // 这种声明就是支持Currying的函数, 每个参数用 ( ) 分隔开
  def modN(n: Int)(x: Int) = ((x % n) == 0)

  // 参数p是有1个Int类型参数的函数, 返回Boolean类型
  def filter(xs: List[Int], p: Int => Boolean): List[Int] =
    if (xs.isEmpty) xs
    else if (p(xs.head)) xs.head :: filter(xs.tail, p)
    else filter(xs.tail, p)

  val nums = List(1, 2, 3, 4, 5, 6, 7, 8)

  // modN2引用的是包含1个Int类型参数, 并返回Boolean类型的函数, 结尾的下划线是Scala中的语法
  val modN2 = modN(2)_
  println(filter(nums, modN2))

  // 不需要赋值的就不需要结尾的下划线了
  println(filter(nums, modN(3)))
}
```

上述代码只是加了额外的注释, 调整了下顺序, 和来源中的代码等价.

最重要的, [Scala][]是静态类型语言, 开发环境可以提供每次`Currying`之后的**函数提示信息**, 并能够做**编译时检查**, 而[Groovy][], [Python][], Javascript只能依赖约定, 错误会在运行时发生, 必须有其它的措施确保同步修改关联的代码.


偏函数 Partial function
------------------------

和Currying很像, 只是另外一种更灵活的语法, 可以不按照参数顺序提供参数, 比如Scala的示例代码:

``` scala
def add(i: Int, j: Int) = i + j
val add5 = add(_: Int, 5)
println(add5(2))
```

参考[Wikipedia][]的[Contrast with partial function application](http://en.wikipedia.org/wiki/Currying#Contrast_with_partial_function_application) 和 [Partial function][wiki Partial function]


Javascript中更常见的传递大量参数的方式
--------------------------------------

Javascript是动态语言, 开发环境无法提供太多提示信息, 上文提到的Currying更适合一些比较稳定的, 不经常变动的API. 

实际项目中如果函数参数很多, 并且可能在不同的地方提供参数, 则会使用参数对象的方式:

``` js
function modN(opt) {
    opt.num = opt.num || 1;
    opt.x = opt.x || 1;
    return opt.x % opt.num === 0;
}

var opt2 = { num: 2 },
    opt3 = { num: 3 };

console.log(filter(nums, function(x) {
    opt2.x = x;
    return modN(opt2);
}));

console.log(filter(nums, function(x) {
    opt3.x = x;
    return modN(opt3);
}));
```

这个看起来和Builder模式十分相像, 参数都提供有默认值, `num`和`x`可以使用更有意义的名称以使阅读性更好一些, 但也付出了不少编码工作.

从[Firefox 2.0][Firefox]开始支持**解构赋值**[New in JavaScript 1.7: Destructuring assignment][Destructuring assignment], 这个特性可以让实现`modN`少了一些纠结:

``` js
function modN(opt) {
    var { num, x } = opt;
    num = num || 1;
    x = x || 1;
    return x % num === 0;
}
```

原文中还有解构赋值的很多[高级用法](https://developer.mozilla.org/en-US/docs/JavaScript/New_in_JavaScript/1.7#Looping_across_values_in_an_array_of_objects), 但是到目前为之还没看到其它浏览器提供支持, 也没有进入ECMAScript标准, 只能在比如Firefox扩展开发时爽爽.

参考资料
--------

-   [Lambda演算与科里化(Currying)](http://www.cnblogs.com/fox23/archive/2009/10/22/intro-to-Lambda-calculus-and-currying.html)
-   [《JavaScript王者归来》第二十二章 科里化（Currying）小节][科里化]
-   [实战 Groovy: 用 curry 过的闭包进行函数式编程][Groovy Curry]
-   [curry -- associating parameters with a function (Python recipe)][Python Curry]
-   [A Tour of Scala: Currying][Scala Curry]
-   [跨越边界: JavaScript 语言特性][]
-   [维基百科 高阶函数 词条][wiki 高阶函数]
-   [维基百科 Currying 词条][wiki Currying]
-   [维基百科 Partial function 词条][wiki Partial function]
-   [New in JavaScript 1.7 : Destructuring assignment 解构赋值][Destructuring assignment]

[科里化]: http://book.51cto.com/art/200806/77578.htm
[Groovy Curry]: http://www.ibm.com/developerworks/cn/java/j-pg08235/
[Python Curry]: http://code.activestate.com/recipes/52549/
[Scala Curry]: http://www.scala-lang.org/node/135
[跨越边界: JavaScript 语言特性]: http://www.ibm.com/developerworks/cn/java/j-cb12196/
[wiki 高阶函数]: http://zh.wikipedia.org/wiki/%E9%AB%98%E9%98%B6%E5%87%BD%E6%95%B0
[wiki Currying]: http://en.wikipedia.org/wiki/Currying
[wiki Partial function]: http://en.wikipedia.org/wiki/Partial_function
[Destructuring assignment]: https://developer.mozilla.org/en-US/docs/JavaScript/New_in_JavaScript/1.7#Destructuring_assignment_%28Merge_into_own_page.2Fsection%29

[维基百科]: http://www.wikipedia.org/
[Scala]: http://www.scala-lang.org/
[Groovy]: http://groovy.codehaus.org/
[Python]: http://www.python.org/
[Firefox]: http://www.mozilla.org/en-US/firefox/fx/#desktop
