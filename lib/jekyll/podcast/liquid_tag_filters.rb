# frozen_string_literal: true

require 'erb'

module Jekyll
  module TagFilters
    def without_index_html(input)
      input.delete_suffix('index.html')
    end

    def tag_permalink(input)
      @context.registers[:site].data['tag_permalinks'][input]
    end

    def episode_url(input)
      input = ERB::Util.url_encode(input)
      tracking_prefix = @context.registers[:site].config.dig('podcast', 'tracking_prefix')
      if tracking_prefix
        "#{tracking_prefix}/assets/episodes/#{input}"
      else
        "/assets/episodes/#{input}"
      end
    end

    def feed_episode_url(input)
      url = episode_url(input)
      if url.start_with?('/')
        site_url = @context.registers[:site].config['url']
        "#{site_url}#{url}"
      else
        url
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::TagFilters)

