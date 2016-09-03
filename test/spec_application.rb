require 'minitest/autorun'
require 'rack/test'
require 'webmock'
require 'wovn/reverse_proxy/application'

include WebMock::API

describe Wovn::ReverseProxy::Application do
  include Rack::Test::Methods

  def app
    Wovn::ReverseProxy::Application
  end

  it 'has Wovn::ReverseProxy::Wovnrb middleware' do
    middlewares = app.middleware
    middlewares.count.must_equal 1
    middlewares[0].must_equal [Wovn::ReverseProxy::Wovnrb, [], nil]
  end

  it 'returns 400 with no host' do
    get '/'
    last_response.status.must_equal 400
    last_response.body.must_equal 'Invalid host parameter.'
  end

  describe 'with use_proxy = false' do
    it 'returns HTML inserted wovn script' do
      WebMock.enable!
      stub_request(:get, 'http://masiuchi.local').to_return(body: 'It works!')
      api_url = 'https://api.wovn.io/v0/values?token=IRb6-&url=masiuchi.local'
      stub_request(:get, api_url).to_return(body: '{}')

      query_params = {}
      env = {
        'HTTP_HOST' => 'masiuchi.local',
        'HTTP_X_WOVN_HOST' => 'http://masiuchi.local',
        'HTTP_X_WOVN_USER_TOKEN' => 'IRb6-',
        'HTTP_X_WOVN_SECRET_KEY' => 'secret',
        'REQUEST_URI' => '/'
      }
      get '/', query_params, env
      last_response.status.must_equal 200
      last_response.body.must_match \
        %r{<script src="//j\.wovn\.io/1" async="true"}

      WebMock.reset!
    end
  end

  describe 'with use_proxy = true' do
    it 'returns HTML inserted wovn script' do
      WebMock.enable!
      stub_request(:get, 'http://masiuchi.local').to_return(body: 'It works!')
      api_url = 'https://api.wovn.io/v0/values?token=IRb6-&url=masiuchi.local'
      stub_request(:get, api_url).to_return(body: '{}')

      query_params = {}
      env = {
        'HTTP_X_FORWARDED_HOST' => 'masiuchi.local',
        'HTTP_X_WOVN_HOST' => 'http://masiuchi.local',
        'HTTP_X_WOVN_USER_TOKEN' => 'IRb6-',
        'HTTP_X_WOVN_SECRET_KEY' => 'secret',
        'HTTP_X_WOVN_USE_PROXY' => 'true',
        'REQUEST_URI' => '/'
      }
      get '/', query_params, env
      last_response.status.must_equal 200
      last_response.body.must_match \
        %r{<script src="//j\.wovn\.io/1" async="true"}

      WebMock.reset!
    end
  end
end
