# frozen_string_literal: true

module Jekyll
  module Podcast
    # creates a filter to turn tag names into links
    module TagLinkFilter
      def tag_link(input)
        tag_href = Jekyll::Podcast::TagPageGenerator.permalink(input, @context.registers[:site])
        "<a class='tag' href='#{tag_href}'>#{input}</a>"
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::Podcast::TagLinkFilter)
