# frozen_string_literal: true

module Jekyll
  module Podcast
    module GuestPageGenerator
      # Adds posts to each guest page on the site
      class Generator < Jekyll::Generator
        def generate(site)
          collect_guest_posts(site)
          site.documents.each do |doc|
            next unless doc.type == :guests

            doc.data['posts'] = @guest_posts[doc.data['title']]
          end
        end

        private

        def collect_guest_posts(site)
          @guest_posts = {}
          site.posts.docs.each do |post|
            next unless post.data['guests']

            post.data['guests'].each do |guest|
              @guest_posts[guest] ||= []
              @guest_posts[guest].push(post)
            end
          end
        end
      end
    end
  end
end
