# frozen_string_literal: true

describe 'the podcast.complete config option', type: :feature do
  context 'when it has a value of true' do
    let(:site) do
      make_site(
        'url' => 'https://flightthroughentirety.com',
        'podcast' => { 'complete' => true }
      )
    end
    let(:feed) { dest_dir('feed', 'podcast') }

    before { site.process }

    it 'produces a feed with an <itunes:complete> element set to Yes' do
      expect(Nokogiri::XML(File.read(feed)).at_xpath('/rss/channel/itunes:complete').content).to eq('Yes')
    end
  end

  context 'when it has a value of false' do
    let(:site) do
      make_site(
        'url' => 'https://flightthroughentirety.com',
        'podcast' => { 'complete' => false }
      )
    end
    let(:feed) { dest_dir('feed', 'podcast') }

    before { site.process }

    it 'produces a feed with no <itunes:complete> element' do
      expect(Nokogiri::XML(File.read(feed)).xpath('/rss/channel/itunes:complete')).to be_empty
    end
  end

  context 'when it does not exist' do
    let(:site) do
      make_site(
        'url' => 'https://flightthroughentirety.com',
        'podcast' => { 'complete' => nil }
      )
    end
    let(:feed) { dest_dir('feed', 'podcast') }

    before { site.process }

    it 'produces a feed with no <itunes:complete> element' do
      expect(Nokogiri::XML(File.read(feed)).xpath('/rss/channel/itunes:complete')).to be_empty
    end
  end
end
