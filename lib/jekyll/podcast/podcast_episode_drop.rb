# frozen_string_literal: true

module Jekyll
  module Drops
    # A new :podcast_element component for the site's permalink structure
    class UrlDrop < Drop
      def podcast_episode
        @obj.data.dig('podcast', 'episode').to_s
      end
    end
  end
end
