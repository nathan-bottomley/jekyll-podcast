# frozen_string_literal: true

require 'jekyll'
require 'mp3info'
require 'json-schema'

require 'jekyll/podcast/version'

module Jekyll
  module Podcast
    class Error < StandardError; end
  end
end

require 'jekyll/podcast/utils'
require 'jekyll/podcast/episode_data'
require 'jekyll/podcast/podcast_episode_drop'
require 'jekyll/podcast/file_exists'
require 'jekyll/podcast/feed_generator'
require 'jekyll/podcast/tag_page_generator'
require 'jekyll/podcast/liquid_tag_filters' # depends on tag_page_generator
require 'jekyll/podcast/contributor_page_generator'
require 'jekyll/podcast/podcast_data'
require 'jekyll/podcast/validate_yaml_frontmatter'
require 'jekyll/podcast/page_title_liquid_tag'
