# frozen_string_literal: true

describe 'the episode_url filter' do
  context 'when episodes are served locally' do
    let(:site) do
      make_site(
        'url' => 'https://flightthroughentirety.com',
        'podcast' => { 'remote_episode_host' => nil }
      )
    end
    let(:context) { make_context(site) }

    it 'returns the correct local episode url' do
      liquid = '{{ file | episode_url }}'
      context['file'] = 'episode-1.mp3'
      rendered = Liquid::Template.parse(liquid).render!(context, strict_variables: true)
      expect(rendered).to eq('https://flightthroughentirety.com/assets/episodes/episode-1.mp3')
    end
  end

  context 'when episodes are served remotely' do
    let(:site) do
      make_site(
        'url' => 'https://flightthroughentirety.com',
        'podcast' => {
          'remote_episode_host' => 'https://example.com'
        }
      )
    end
    let(:context) { make_context(site) }

    it 'returns the correct remote episode url' do
      liquid = '{{ file | episode_url }}'
      context['file'] = 'episode-1.mp3'
      rendered = Liquid::Template.parse(liquid).render!(context, strict_variables: true)
      expect(rendered).to eq('https://example.com/episode-1.mp3')
    end
  end

  context 'when a tracking prefix is present' do
    let(:site) do
      make_site(
        'url' => 'https://flightthroughentirety.com',
        'podcast' => {
          'remote_episode_host' => nil,
          'tracking_prefix' => 'https://dts.podtrac.com/redirect.mp3'
        }
      )
    end
    let(:context) { make_context(site) }

    it 'returns the correct local episode url with tracking prefix' do
      liquid = '{{ file | episode_url }}'
      context['file'] = 'episode-1.mp3'
      rendered = Liquid::Template.parse(liquid).render!(context, strict_variables: true)
      expect(rendered).to eq('https://dts.podtrac.com/redirect.mp3/assets/episodes/episode-1.mp3')
    end
  end

  context 'when a tracking prefix is present and episodes are served remotely' do
    let(:site) do
      make_site(
        'url' => 'https://flightthroughentirety.com',
        'podcast' => {
          'remote_episode_host' => 'https://example.com',
          'tracking_prefix' => 'https://dts.podtrac.com/redirect.mp3'
        }
      )
    end
    let(:context) { make_context(site) }

    it 'returns the correct remote episode url with tracking prefix' do
      liquid = '{{ file | episode_url }}'
      context['file'] = 'episode-1.mp3'
      rendered = Liquid::Template.parse(liquid).render!(context, strict_variables: true)
      expect(rendered).to eq('https://dts.podtrac.com/redirect.mp3/example.com/episode-1.mp3')
    end
  end
end
