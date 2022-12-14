# frozen_string_literal: true

module Jekyll
  module Podcast
    # Liquid tag for generating a page title
    class PageTitleTag < Liquid::Tag
      def render(context)
        site_title = context.registers[:site].config['title']
        page_title = context.registers[:page]['title']

        if page_title.nil? || page_title.empty? || page_title == site_title
          "<title>#{site_title}</title>"
        else
          "<title>#{page_title} &middot; #{site_title}</title>"
        end
      end
    end

    # Liquid tag for generating the text of a page title 
    # without the <title> tag
    class PageTitleTextTag < Liquid::Tag
      def render(context)
        site_title = context.registers[:site].config['title']
        page_title = context.registers[:page]['title']

        if page_title.nil? || page_title.empty? || page_title == site_title
          site_title
        else
          "#{page_title} &middot; #{site_title}"
        end
      end
    end
  end
end

Liquid::Template.register_tag('pagetitle', Jekyll::Podcast::PageTitleTag)
Liquid::Template.register_tag('pagetitletext', Jekyll::Podcast::PageTitleTextTag)
