# frozen_string_literal: true

module Jekyll
  module Podcast
    # Generator to create tag pages for each tag on the site
    module TagPageGenerator
      # The generator itself
      class Generator < Jekyll::Generator
        def generate(site)
          site.tags.each do |tag, _|
            site.pages << TagPage.new(site, tag)
          end
        end
      end

      # Represents a tag page; includes pagination information
      class TagPage < Jekyll::Page
        def initialize(site, tag)
          super(site, site.baseurl, '/', 'index.html')
          @tag = tag
          @data ||= {}
          @data['permalink'] = Jekyll::Podcast::TagPageGenerator.permalink(@tag, site)
          @data['layout'] = 'tag-page'
          @data['title'] = tag
          @data['pagination'] = pagination(site)
        end

        def pagination(site)
          pagination_config = site.config.dig('tag_pages', 'pagination') || {}
          {
            'enabled' => true,
            'tag' => @tag,
            'sort_reverse' => false
          }.merge(pagination_config)
        end
      end

      def self.permalink(tag, site)
        if site.data['tag_permalinks'] && site.data['tag_permalinks'][tag]
          site.data['tag_permalinks'][tag]
        else
          "/#{Jekyll::Utils.slugify(tag)}/"
        end
      end
    end
  end
end
