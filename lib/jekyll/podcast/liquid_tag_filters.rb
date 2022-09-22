# frozen_string_literal: true

require 'erb'

module Jekyll
  module Podcast
    # Define tag filters for podcasting
    module TagFilters
      def without_index_html(input)
        input.delete_suffix('index.html')
      end

      def tag_permalink(input)
        site.data['tag_permalinks'][input]
      end

      def episode_url(input)
        input = ERB::Util.url_encode(input)
        File.join(url_prefix, input)
      end

      def tag_link(input)
        tag_href = Jekyll::Podcast::TagPageGenerator.permalink(input, @context.registers[:site])
        "<a class='tag' href='#{tag_href}'>#{input}</a>"
      end

      private

      def url_prefix
        if tracking_prefix && remote_episode_host
          url_prefix_with_tracking_prefix_and_remote_episode_host
        elsif tracking_prefix
          url_prefix_with_tracking_prefix_and_no_remote_episode_host
        elsif remote_episode_host
          url_prefix_with_no_tracking_prefix_and_remote_episode_host
        else
          File.join(site.config['url'], 'assets', 'episodes')
        end
      end

      def url_prefix_with_tracking_prefix_and_remote_episode_host
        File.join(tracking_prefix, remote_episode_host.sub(%r{^https?://}, ''))
      end

      def url_prefix_with_tracking_prefix_and_no_remote_episode_host
        File.join(tracking_prefix, 'assets', 'episodes')
      end

      def url_prefix_with_no_tracking_prefix_and_remote_episode_host
        remote_episode_host
      end

      def tracking_prefix
        @context.registers[:site].config['podcast']['tracking_prefix']
      end

      def remote_episode_host
        @context.registers[:site].config['podcast']['remote_episode_host']
      end

      def site
        @context.registers[:site]
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::Podcast::TagFilters)
