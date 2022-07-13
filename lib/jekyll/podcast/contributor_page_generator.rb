# frozen_string_literal: true

module Jekyll
  module Podcast
    module ContributorPageGenerator
      # Adds posts to each contributor page on the site
      class Generator < Jekyll::Generator
        def generate(site)
          @site = site
          collect_contributor_posts
          @site.documents.each do |doc|
            next unless doc.type == contributors_alias.to_sym

            doc.data['posts'] = @contributor_posts[doc.data['title']]
          end
        end

        private

        def collect_contributor_posts
          @contributor_posts = {}
          @site.posts.docs.each do |post|
            next unless post.data[contributors_alias]

            post.data[contributors_alias].each do |contributor|
              @contributor_posts[contributor] ||= []
              @contributor_posts[contributor].push(post)
            end
          end
        end

        def contributors_alias
          @site.config['podcast']['contributors_alias'] || 'contributors'
        end
      end
    end
  end
end
