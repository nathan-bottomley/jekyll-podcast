# frozen_string_literal: true

module Jekyll
  module Podcast
    # Class representing feed page
    class FeedPage < Jekyll::Page
      def read_yaml(*)
        @data ||= {} # rubocop:disable Naming/MemoizedInstanceVariableName
      end
    end

    # Generator for podcast feed
    class FeedGenerator < Jekyll::Generator
      def generate(site)
        @site = site
        site.pages << new_feed_page
      end

      def new_feed_page
        feed_page = FeedPage.new(@site, __dir__, '', 'feed/podcast')
        template_path = File.expand_path('podcast.xml', __dir__)
        feed_page.content = File.read(template_path)
        feed_page.data['layout'] = nil
        feed_page.output
        feed_page
      end
    end
  end
end
