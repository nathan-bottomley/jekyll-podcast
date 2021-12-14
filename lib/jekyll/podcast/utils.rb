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
      end
    end
  end
end
