# frozen_string_literal: true

module Jekyll
  module Podcast
    # Calculate the total count and duration of all podcast episodes
    module PodcastData
      class << self
        def episodes_dir
          Jekyll::Podcast::Utils.episodes_dir(@site)
        end

        def episodes
          Dir.children(episodes_dir).select { |x| x.end_with?('.mp3') }
        end

        def total_duration_in_seconds
          episodes.sum do |mp3|
            Mp3Info.open(File.join(episodes_dir, mp3), &:length)
          end
        end

        def total_size_in_megabytes
          size_in_bytes = episodes.sum do |mp3|
            File.size(File.join(episodes_dir, mp3))
          end
          "#{(size_in_bytes / 1_000_000.0).round(1)} MB"
        end

        def podcast_data
          result = Jekyll::Podcast::Utils.duration(total_duration_in_seconds)
          result[:count] = episodes.length
          result[:size] = total_size_in_megabytes
          result
        end

        def podcast_data_log_entry(site)
          @site = site
          if Dir.exist?(episodes_dir)
            format(
              '%<count>d episodes; %<size>s;'\
              '%<days>d d %<hours>d h %<minutes>d min %<seconds>0.3f s',
              podcast_data
            )
          else
            "No episodes directory found at #{episodes_dir}"
          end
        end
      end
    end
  end
end

Jekyll::Hooks.register :site, :post_write do |site|
  Jekyll.logger.info Jekyll::Podcast::PodcastData.podcast_data_log_entry(site).yellow
end
