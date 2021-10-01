# frozen_string_literal: true

Jekyll::Hooks.register :site, :after_init do |site|
  required_keys = %w[title subtitle author description language summary owner email explicit category]
  missing_keys = required_keys.reject { |x| site.config['podcast'].key?(x) }
  Jekyll.logger.warn "Podcast config is missing keys #{missing_keys}" unless missing_keys.empty?
end

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
        feed_page
      end
    end
  end
end
