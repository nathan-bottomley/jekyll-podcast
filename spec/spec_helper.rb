# frozen_string_literal: true

require 'jekyll'
require 'jekyll/podcast'

Jekyll.logger.log_level = :error

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end

def source_dir(*files)
  source_dir = File.expand_path('fixtures', __dir__)
  File.join(source_dir, *files)
end

def dest_dir(*files)
  dest_dir = File.expand_path('dest', __dir__)
  File.join(dest_dir, *files)
end

def config_defaults
  {
    'source' => source_dir,
    'destination' => dest_dir,
    'gems' => ['jekyll-podcast'],
    'collections' => ['my_collection'],
    'podcast' => {
      'title' => 'Flight Through Entirety',
      'episode_url_prefix' => 'https://example.com/episodes/'
    }
  }.freeze
end

def make_page(options = {})
  page = Jekyll::Page.new(site, config_defaults['source'], '', 'page.md')
  page.data = options
  page
end

def make_site(options = {})
  site_config = Jekyll.configuration(config_defaults.merge(options))
  Jekyll::Site.new(site_config)
end

def make_context(site)
  Liquid::Context.new(
    {},
    {},
    { site: site }
  )
end
