# frozen_string_literal: true

require 'erb'
require 'mp3Info'
require_relative 'utils'
require 'jekyll'

module Jekyll
  # Define duration method in Jekyll::Podcast to convert from seconds to string for feed
  module Podcast
    # Class responsible for setting episode data on a post's page
    class EpisodeData
      def initialize(payload)
        @site = payload['site']
        @page = payload['page']
        @file_path = "assets/episodes/#{@page['podcast']['file']}"
        @escaped_file_path = "assets/episodes/#{ERB::Util.url_encode(@page['podcast']['file'])}"
      end

      def add_episode_data
        @page['podcast'].merge!({ 'audio_file' => audio_file,
                                  'audio_url' => audio_url,
                                  'size' => size,
                                  'size_in_megabytes' => size_in_megabytes,
                                  'duration' => duration(seconds),
                                  'guid' => guid })
      end

      def audio_file
        if @site['podcast']['tracking_prefix']
          "#{@site['podcast']['tracking_prefix']}/#{@escaped_file_path}"
        else
          "/#{@escaped_file_path}"
        end
      end

      def audio_url
        if @site['podcast']['tracking_prefix']
          "#{@site['podcast']['tracking_prefix']}/#{@escaped_file_path}"
        else
          "#{@site['url']}/#{@escaped_file_path}"
        end
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
        @page['podcast']['guid'] || "#{@site['url']}#{@page['url']}"
      end
    end
  end
end

Jekyll::Hooks.register :posts, :pre_render, priority: 'high' do |_page, payload|
  Jekyll::Podcast::EpisodeData.new(payload).add_episode_data
end
