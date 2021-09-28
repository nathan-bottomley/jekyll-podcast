# frozen_string_literal: true

require 'mp3Info'

module Jekyll
  module Podcast
    class << self
      def duration(seconds)
        seconds = seconds.to_f.round
        h, rem = seconds.divmod(3600)
        m, s   = rem.divmod(60)
        m = m.to_s.rjust(2, '0')
        s = s.to_s.rjust(2, '0')
        "#{h}:#{m}:#{s}"
      end
    end
  end
end

Jekyll::Hooks.register :posts, :pre_render, priority: 'high' do |_content, doc|
  doc.page['podcast'] ||= {}
  mp3_path = "assets/episodes/#{doc.page['podcast']['file']}"
  next unless File.exist?(mp3_path)

  size = File.size(mp3_path)
  doc.page['podcast']['size'] = size
  doc.page['podcast']['size_in_megabytes'] = "#{(size / 1_000_000).round(1)} MB"

  Mp3Info.open(mp3_path) do |mp3|
    doc.page['podcast']['duration'] = Jekyll::Podcast.duration(mp3.length)
  end
end
