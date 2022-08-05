# frozen_string_literal: true

require 'nokogiri'

describe 'The podcast feed generator', type: :feature do
  let(:site) { make_site('url' => 'https://flightthroughentirety.com') }
  let(:feed) { dest_dir('feed', 'podcast') }

  before { site.process }

  it 'creates a podcast feed' do
    expect(Pathname.new(feed)).to exist
  end

  it 'creates a podcast feed which is valid XML' do
    expect(Nokogiri::XML(File.read(feed)).errors).to be_empty
  end

  it 'creates a podcast feed with an <rss> root element' do
    expect(Nokogiri::XML(File.read(feed)).root.name).to eq('rss')
  end

  describe 'the podcast feed xml' do
    let(:site) { make_site('url' => 'https://flightthroughentirety.com') }
    let(:feed) { dest_dir('feed', 'podcast') }

    before { site.process }

    it 'has a title element' do
      title_element = Nokogiri::XML(File.read(feed)).at_xpath('rss/channel/title')
      expect(title_element.content).to eq('Flight Through Entirety')
    end

    it 'has an <atom:link> element' do
      expect(Nokogiri::XML(File.read(feed)).at_xpath('/rss/channel/atom:link').content).not_to be_nil
    end

    it 'has an <atom:link> element with a rel attribute of self' do
      expect(Nokogiri::XML(File.read(feed)).at_xpath('/rss/channel/atom:link/@rel').content).to eq('self')
    end

    it 'has an <atom:link> element with a correct href attribute' do
      expect(Nokogiri::XML(File.read(feed)).at_xpath('/rss/channel/atom:link/@href').content).to eq('https://flightthroughentirety.com/feed/podcast')
    end

    it 'has an <atom:link> element with a type attribute of application/rss+xml' do
      link_element_type_attribute = Nokogiri::XML(File.read(feed)).at_xpath('/rss/channel/atom:link/@type')
      expect(link_element_type_attribute.content).to eq('application/rss+xml')
    end
  end
end
