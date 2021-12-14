# frozen_string_literal: true

require_relative 'utils'
module Jekyll
  module Podcast
    # Calculate the total count and duration of all podcast episodes
    module PodcastData
      class << self
        def podcast_data
          episodes = Dir.children('assets/episodes').select { |x| x.end_with?('.mp3') }
          count = episodes.length
          duration_in_seconds = episodes.sum { |mp3| Mp3Info.open("assets/episodes/#{mp3}", &:length) }
          size_in_bytes = episodes.sum { |mp3| File.size("assets/episodes/#{mp3}") }
          result = Jekyll::Podcast::Utils.duration(duration_in_seconds)
          result[:count] = count
          result[:size] = "#{(size_in_bytes / 1_000_000.0).round(1)} MB"
          result
        end

        def podcast_data_log_entry
          format('%<count>d episodes; %<size>s; %<days>d d %<hours>d h %<minutes>d min %<seconds>0.3f s',
                 podcast_data)
        end
      end
    end
  end
end

Jekyll::Hooks.register :site, :post_write do |_site|
  Jekyll.logger.info Jekyll::Podcast::PodcastData.podcast_data_log_entry.yellow
end
