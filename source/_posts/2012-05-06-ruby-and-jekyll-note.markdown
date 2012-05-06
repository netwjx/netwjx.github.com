---
layout: post
title: "Ruby 和 Jekyll 的笔记"
date: 2012-05-06 15:57
comments: true
categories: Ruby Octopress Jekyll Liquid
---

之前发现[Octopress][]产生的页面中, **meta**标签的**content**属性没有处理换行, 今天尝试自己写个插件来处理这个地方, 因为没有学过Ruby, 下面的操作基本都是临时找资料, 所以记录一些重点.

插件代码如下

``` ruby plugins/html_attr_filter.rb
# coding: utf-8

#html attribute filter
module HtmlAttrFilters
    def html_attr(input)
        input.gsub(/\r\n|\r|\n/, "\r\n"=>'&#13;&#10;', "\r"=>'&#13;', "\n"=>'&#10;')
    end
end

Liquid::Template.register_filter HtmlAttrFilters
```

修改`source/_includes/head.html`中`<meta name="description"`所在的行

``` html source/_includes/head.html
  <meta name="description" content="{{ description | strip_html | condense_spaces | truncate:150 | html_attr }}">
```

然后`rake generate`就能看到`<meta name="description"`的**content**已经不会有换行了, 下面说说中间涉及的相关东西.


Jekyll扩展和Liquid扩展
----------------------

[Octopress][]是基于[Jekyll][]的, [Jekyll][]使用的模版引擎是[Liquid][], 在模版中`{{ "{{ a | foo | bar" }}}}`的`foo`和`bar`叫做**Filter**, 后面将把其称为**过滤器**, 在[Jekyll][]的[插件开发文档](https://github.com/mojombo/jekyll/wiki/Plugins)中有一段是关于过滤器扩展, 我主要是参考这里来做文章开始的扩展.


### Liquid filters

You can add your own filters to the liquid system much like you can add tags above. Filters are simply modules that export their methods to liquid. All methods will have to take at least one parameter which represents the input of the filter. The return value will be the output of the filter.

``` ruby
module Jekyll
  module AssetFilter
    def asset_url(input)      
      "http://www.example.com/#{input}?#{Time.now.to_i}"
    end
  end
end

Liquid::Template.register_filter(Jekyll::AssetFilter)
```

**Advanced**: you can access the `site` object through the `@context.registers` feature of liquid. Registers a hash where arbitrary context objects can be attached to. In Jekyll you can access the site object through registers. As an example, you can access the global configuration (_config.yml) like this: `@context.registers[:site].config['cdn']`.


### 延伸: Octopress Jekyll和Liquid所有可用的过滤器

[Octopress][]扩展的过滤器在[这里](https://github.com/imathis/octopress/blob/master/plugins/octopress_filters.rb), 主要是从36行开始的这些:

``` ruby plugins/octopress_filters.rb
module OctopressLiquidFilters
  include Octopress::Date

  # Used on the blog index to split posts on the <!--more--> marker
  def excerpt(input)
    if input.index(/<!--\s*more\s*-->/i)
      input.split(/<!--\s*more\s*-->/i)[0]
    else
      input
    end
  end

  # Checks for excerpts (helpful for template conditionals)
  def has_excerpt(input)
    input =~ /<!--\s*more\s*-->/i ? true : false
  end

  # Summary is used on the Archive pages to return the first block of content from a post.
  def summary(input)
    if input.index(/\n\n/)
      input.split(/\n\n/)[0]
    else
      input
    end
  end

  # Extracts raw content DIV from template, used for page description as {{ content }}
  # contains complete sub-template code on main page level
  def raw_content(input)
    /<div class="entry-content">(?<content>[\s\S]*?)<\/div>\s*<(footer|\/article)>/ =~ input
    return (content.nil?) ? input : content
  end

  # Escapes CDATA sections in post content
  def cdata_escape(input)
    input.gsub(/<!\[CDATA\[/, '&lt;![CDATA[').gsub(/\]\]>/, ']]&gt;')
  end

  # Replaces relative urls with full urls
  def expand_urls(input, url='')
    url ||= '/'
    input.gsub /(\s+(href|src)\s*=\s*["|']{1})(\/[^\"'>]*)/ do
      $1+url+$3
    end
  end

  # Improved version of Liquid's truncate:
  # - Doesn't cut in the middle of a word.
  # - Uses typographically correct ellipsis (…) insted of '...'
  def truncate(input, length)
    if input.length > length && input[0..(length-1)] =~ /(.+)\b.+$/im
      $1.strip + ' &hellip;'
    else
      input
    end
  end

  # Improved version of Liquid's truncatewords:
  # - Uses typographically correct ellipsis (…) insted of '...'
  def truncatewords(input, length)
    truncate = input.split(' ')
    if truncate.length > length
      truncate[0..length-1].join(' ').strip + ' &hellip;'
    else
      input
    end
  end

  # Condenses multiple spaces and tabs into a single space
  def condense_spaces(input)
    input.gsub(/\s{2,}/, ' ')
  end

  # Removes trailing forward slash from a string for easily appending url segments
  def strip_slash(input)
    if input =~ /(.+)\/$|^\/$/
      input = $1
    end
    input
  end

  # Returns a url without the protocol (http://)
  def shorthand_url(input)
    input.gsub /(https?:\/\/)(\S+)/ do
      $2
    end
  end

  # Returns a title cased string based on John Gruber's title case http://daringfireball.net/2008/08/title_case_update
  def titlecase(input)
    input.titlecase
  end

end
Liquid::Template.register_filter OctopressLiquidFilters
```

`def `后的名称即过滤器的名称.

[Jekyll][]扩展的过滤器在[这里](https://github.com/mojombo/jekyll/wiki/Liquid-Extensions)

[Liquid][]的标准过滤器在[这里](https://github.com/shopify/liquid/wiki/liquid-for-designers)


Ruby的字符串和正则
------------------

Ruby的字符串可以使用双引号`"foo bar"`, 也可以使用单引号`'foo bar'`, 区别是:

*   双引号中可以使用`\r\n`等转义符号, 以及`#{bar}`来引入一个变量的值, `bar`表示一个变量名.
*   单引号会将所有的字符原样保留, 包括`\r\n`, 其等价于双引号的`\\r\\n`.

Ruby字符串的替换可以使用`gsub`方法, 类似一般语言中的`replace`, 第一个参数仍旧可以为正则, Ruby的文档中代码示例如下:

``` ruby String#gsub
"hello".gsub(/[aeiou]/, '*')                  #=> "h*ll*"
"hello".gsub(/([aeiou])/, '<\1>')             #=> "h<e>ll<o>"
"hello".gsub(/./) {|s| s.ord.to_s + ' '}      #=> "104 101 108 108 111 "
"hello".gsub(/(?<foo>[aeiou])/, '{\k<foo>}')  #=> "h{e}ll{o}"
'hello'.gsub(/[eo]/, 'e' => 3, 'o' => '*')    #=> "h3ll*"
```

我没有完整的看Ruby的语言规范, 根据文档的描述, 示例代码中最后一行`'e' => 3, 'o' => '*'`叫做**Hash**.

另外一个方法`sub`和`gsub`区别在: `sub`只会替换一次, `gsub`会替换所有的.

更多资料:

*    [Ruby基础类型](http://www.ruby-doc.org/docs/ProgrammingRuby/html/tut_stdtypes.html)中还有更多关于`String`类型的基础.
*    [类库参考 String](http://www.ruby-doc.org/core-1.9.3/String.html)中有完整的`String`可使用.

Ruby中正则的使用感觉和Javascript的十分象, 当然也有一些其它的语法, 详细参考[Ruby类库参考 Regexp](http://www.ruby-doc.org/core-1.9.3/Regexp.html)

发现一个特别的地方是Javascript中正则可以使用的选项有`igm`, 而Ruby是`imxo`, 见[这里](http://www.ruby-doc.org/core-1.9.3/Regexp.html)**的Options**


[Octopress]: http://octopress.org/
[Jekyll]: https://github.com/mojombo/jekyll
[Liquid]: https://github.com/Shopify/liquid/wiki