# coding: utf-8

#html attribute filter
module HtmlAttrFilters
    def html_attr(input)
        input.gsub(/\r\n|\r|\n/, "\r\n"=>'&#13;&#10;', "\r"=>'&#13;', "\n"=>'&#10;')
    end
end

Liquid::Template.register_filter HtmlAttrFilters
