# frozen_string_literal: true

module Jekyll
  module Podcast
    # Calculate the total count and duration of all podcast episodes
    module PodcastInformation
      class << self
        def duration(seconds)
          mm, ss = seconds.divmod(60)
          hh, mm = mm.divmod(60)
          dd, hh = hh.divmod(24)
          {
            days: dd,
            hours: hh,
            minutes: mm,
            seconds: ss
          }
        end

        def podcast_information
          episodes = Dir.children('assets/episodes').select { |x| x.end_with?('.mp3') }
          count = episodes.length
          duration_in_seconds = episodes.sum { |mp3| Mp3Info.open("assets/episodes/#{mp3}", &:length) }
          result = duration(duration_in_seconds)
          result[:count] = count
          result
        end

        def podcast_information_log_entry
          format('%<count>d episodes; %<days>d d %<hours>d h %<minutes>d min %<seconds>0.3f s', podcast_information)
        end
      end
    end
  end
end

Jekyll::Hooks.register :site, :post_write do |_site|
  Jekyll.logger.info Jekyll::Podcast::PodcastInformation.podcast_information_log_entry.yellow
end
