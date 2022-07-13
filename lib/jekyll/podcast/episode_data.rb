# frozen_string_literal: true

require 'mp3Info'
require_relative 'utils'
require 'jekyll'

module Jekyll
  # Define duration method in Jekyll::Podcast to convert from seconds to string for feed
  module Podcast
    # Class responsible for setting episode data on a post's page
    class EpisodeData
      def initialize(page, payload)
        @site = page.site
        @page = payload['page']
        @file_path = File.join(Jekyll::Podcast::Utils.episodes_dir(@site), @page['podcast']['file'])
      end

      def add_episode_data
        @page['podcast'].merge!({ 'size' => size,
                                  'size_in_megabytes' => size_in_megabytes,
                                  'duration' => duration(seconds),
                                  'guid' => guid })
      end

      def size
        if File.exist? @file_path
          File.size(@file_path)
        else
          0
        end
      end

      def size_in_megabytes
        "#{(size / 1_000_000.0).round(1)} MB"
      end

      def seconds
        if File.exist? @file_path
          Mp3Info.open(@file_path, &:length)
        else
          0
        end
      end

      def duration(seconds)
        format('%<hours>d:%<minutes>02d:%<seconds>02d',
               Jekyll::Podcast::Utils.duration(seconds))
      end

      def guid
        @page['podcast']['guid'] || "#{@site.config['url']}#{@page['url']}"
      end
    end
  end
end

Jekyll::Hooks.register :posts, :pre_render, priority: 'high' do |page, payload|
  Jekyll::Podcast::EpisodeData.new(page, payload).add_episode_data
end
