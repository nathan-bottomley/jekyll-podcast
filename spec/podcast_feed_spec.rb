# frozen_string_literal: true

require 'nokogiri'

describe 'the podcast feed' do
  let(:site) { make_site }
  let(:feed) { dest_dir('feed', 'podcast') }
  before { site.process }

  it 'exists' do
    expect(Pathname.new(feed)).to exist
  end

  it 'is valid XML' do
    expect(Nokogiri::XML(File.read(feed)).errors).to be_empty
  end

  it 'has an <rss> root element' do
    expect(Nokogiri::XML(File.read(feed)).root.name).to eq('rss')
  end
end

describe 'the podcast feed contents' do
  let(:site) { make_site('url' => 'https://flightthroughentirety.com') }
  let(:feed) { dest_dir('feed', 'podcast') }
  before { site.process }

  it 'has a title' do
    expect(Nokogiri::XML(File.read(feed)).at_xpath('/rss/channel/title').content).to eq('Flight Through Entirety')
  end

  it 'has an <atom:link> element' do
    expect(Nokogiri::XML(File.read(feed)).at_xpath('/rss/channel/atom:link').content).to eq('http://example.org/feed/podcast/')
  end

  it 'has an <atom:link> element with a rel attribute' do
    expect(Nokogiri::XML(File.read(feed)).at_xpath('/rss/channel/atom:link/@rel').content).to eq('self')
  end

  it 'has an <atom:link> element with an href attribute' do
    expect(Nokogiri::XML(File.read(feed)).at_xpath('/rss/channel/atom:link/@href').content).to eq('http://example.org/feed/podcast/')
  end

  it 'has an <atom:link> element with an href attribute that ends in .xml' do
    expect(Nokogiri::XML(File.read(feed)).at_xpath('/rss/channel/atom:link/@href').content).to end_with('.xml')
  end

  it 'has an <atom:link> element with an href attribute that is an absolute URL' do
    expect(Nokogiri::XML(File.read(feed)).at_xpath('/rss/channel/atom:link/@href').content).to start_with('http')
  end

  it 'has an <atom:link> element with an href attribute that is an absolute URL' do
    expect(Nokogiri::XML(File.read(feed)).at_xpath('/rss/channel/atom:link/@href').content).to start_with('http')
  end
end
