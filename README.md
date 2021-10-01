# Jekyll::Podcast

`jekyll-podcast` is a straightforward, opinionated Jekyll plugin which provides you with the functionality you need to  use a Jekyll site to host a fully-featured podcast.

`jekyll-podcast` will create your podcast feed and will provide you with the tools you need to make a simple but effective podcast site.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jekyll-podcast'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install jekyll-podcast

## Features

The `jekyll-podcast` plugin

- creates a podcast feed based on the information you provide in `_config.yml` and your post's front matter
- analyses your podcast's MP3 files and makes information about them available to your templates
- provides a simple tagging system and creates tag pages for your site

## Usage

### `_config.yml`

Here is a sample set of podcast preferences for your `config.yml` file.

```yaml
podcast:
  language: en-AU
  author: Flight Through Entirety
  owner: Nathan Bottomley
  explicit: false
  category: TV &amp; Film
  tracking_prefix: https://dts.podtrac.com/redirect.mp3/flightthroughentirety.com
```

### Post Front Matter

```yaml
tags:
- Series 6
- The Eleventh Doctor
podcast:
  episode: 218
  file: >-
    FTE 218, Everyone Is Now Sporting a Beard (The Curse of the Black Spot).mp3
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/furius95/jekyll-podcast.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
