---
layout: post
title: "Jekyll插件:分类云"
date: 2012-06-03 14:55
comments: true
categories: Jekyll Octopress Plugin Ruby
---

Octopress默认有存档页, 但是没有能列出所有分类的页面, 我试图找这方面的插件, 但是尝试使用的一些都不是很理想, 所以尝试自己写了一个这样的插件, 效果就如导航栏链接[分类](/blog/categories/) 哪样.

以下是代码, 多数代码都是从Jeykll插件示例中抄的, 第一次写实用的ruby程序, 也没多想注释什么的.

<!-- more -->

``` ruby plugins/category_cloud.rb
module Jekyll
  class CategoryCloudPage < Page
    def initialize(site, base, dir, cloud)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'category_cloud.html')

      self.data['cloud'] = cloud
    end
  end

  class CategoryCloudGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'category_cloud'
        dir = site.config['category_dir'] || 'categories'

        count = site.categories.map do |item|
          [item[0], item[1].length]
        end

        maxsize = 5
        minsize = 1
        min, max = count.map(&:last).minmax

        cloud = site.categories.map do |name, posts|
          {
            "title" => name,
            "rank"  => maxsize + minsize - ((posts.length - min) * (maxsize - minsize) / (max - min) + minsize),
            "link"  => "/#{dir}/#{name.gsub(/_|\P{Word}/, '-').gsub(/-{2,}/, '-').downcase}/"
          }
        end

        index = CategoryCloudPage.new(site, site.source, dir, cloud)
        index.render(site.layouts, site.site_payload)
        index.write(site.dest)
        site.pages << index
      end
    end
  end

end
```

``` scss sass/partials/_category_cloud.scss
.category-cloud {
    @for $i from 1 through 5 {
        .rank-#{$i} { font-size: nth(230% 210% 180% 140% 90%, $i); }
    }
    .rank-1, .rank-2, .rank-3, .rank-4 { font-weight:bold; }
    span { line-height: 1.25em; padding:0 5px; }
}
```

需要修改`sass/_partials.scss`, 结尾加入一行
``` scss sass/_partials.scss
@import "partials/category_cloud"
```

``` html source/_layouts/category_cloud.html
---
layout: page
title: 分类
footer: false
---
{% raw %}
<div class="category-cloud">
    {% for item in page.cloud %}
        <span class="rank-{{ item.rank }}"><a href="{{ item.link }}">{{ item.title }}</a></span>
    {% endfor %}
</div>{% endraw %}
```

目前只做了生成分类页面, 侧边栏还没有做, 以后有做的冲动了再说吧.


参考资料
--------

-	[Migrating from Wordpress to Jekyll - Part 2](http://vitobotta.com/how-to-migrate-from-wordpress-to-jekyll/) Tag cloud 段落

-	[How to create a tag cloud? (With formula and sample calculation) ](http://blog.16codes.com/2007/12/how-to-create-tag-cloud-with-formula.html) 算法

-	[octopress / plugins / category_generator.rb](https://github.com/imathis/octopress/blob/master/plugins/category_generator.rb) Octopress修改的具体分类页面生成插件