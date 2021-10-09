# frozen_string_literal: true

module Jekyll
  module Podcast
    # Calculate the total duration of all podcast episodes
    module PodcastDuration
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

        def total_podcast_duration
          result = 0
          Dir.children('assets/episodes').each do |mp3|
            next unless mp3.end_with?('.mp3')

            path = "assets/episodes/#{mp3}"
            result += Mp3Info.open(path, &:length)
          end
          result
        end

        def total_podcast_duration_log_entry
          format(
            'Total podcast duration is %<days>d:%<hours>02d:%<minutes>02d:%<seconds>.3f',
            duration(total_podcast_duration)
          )
        end
      end
    end
  end
end

Jekyll::Hooks.register :site, :post_write do |_site|
  Jekyll.logger.info Jekyll::Podcast::PodcastDuration.total_podcast_duration_log_entry.yellow
end
