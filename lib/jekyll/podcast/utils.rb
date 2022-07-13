# frozen_string_literal: true

module Jekyll
  module Podcast
    # Utility functions used in jekyll-podcast
    module Utils
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

        def episodes_dir(site)
          if site.config['podcast']['remote_episode_host']
            File.join(site.source, '_episodes')
          else
            File.join(site.source, 'assets/episodes')
          end
        end
      end
    end
  end
end
