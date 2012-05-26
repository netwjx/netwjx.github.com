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