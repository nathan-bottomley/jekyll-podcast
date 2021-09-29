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
        @context.registers[:site].data['tag_permalinks'][input]
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::Podcast::TagFilters)
