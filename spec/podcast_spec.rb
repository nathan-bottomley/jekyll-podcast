# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Jekyll::Podcast do
  let(:site) { make_site }
  before { site.process }

  it 'has a version number' do
    expect(Jekyll::Podcast::VERSION).not_to be nil
  end

  it 'creates a podcast feed' do
    expect(Pathname.new(dest_dir('feed', 'podcast'))).to exist
  end
end
