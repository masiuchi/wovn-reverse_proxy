require 'minitest/autorun'
require 'rack/lint'
require 'rack/mock'
require 'wovn/reverse_proxy/wovnrb'

describe Wovn::ReverseProxy::Wovnrb do
  it 'inherits Wovnrb::Interceptor' do
    Wovn::ReverseProxy::Wovnrb.superclass.must_equal Wovnrb::Interceptor
  end

  it 'has setting_keys' do
    middleware = Wovn::ReverseProxy::Wovnrb.new(app)
    setting_keys = middleware.instance_variable_get('@setting_keys')
    setting_keys.must_include 'user_token'
    setting_keys.must_include 'secret_key'
    setting_keys.must_include 'url_pattern'
  end

  it 'resets its settings in every request' do
    middleware = Wovn::ReverseProxy::Wovnrb.new(app)
    middleware.call env('HTTP_X_WOVN_URL_PATTERN' => 'subdomain')
    settings(middleware)['url_pattern'].must_equal 'subdomain'
    middleware.call env
    settings(middleware)['url_pattern'].must_equal 'path'
  end

  it 'has "use_proxy = true" when value is "TRUE"' do
    middleware = Wovn::ReverseProxy::Wovnrb.new(app)
    middleware.call env('HTTP_X_WOVN_USE_PROXY' => 'TRUE')
    settings(middleware)['use_proxy'].must_equal true
  end

  it 'has "use_proxy = true" when value is "on"' do
    middleware = Wovn::ReverseProxy::Wovnrb.new(app)
    middleware.call env('HTTP_X_WOVN_USE_PROXY' => 'on')
    settings(middleware)['use_proxy'].must_equal true
  end

  it 'has "use_proxy = true" when value is "1"' do
    middleware = Wovn::ReverseProxy::Wovnrb.new(app)
    middleware.call env('HTTP_X_WOVN_USE_PROXY' => '1')
    settings(middleware)['use_proxy'].must_equal true
  end

  def settings(middleware)
    middleware.instance_variable_get('@store').settings
  end

  def env(opts = {})
    Rack::MockRequest.env_for('/', opts)
  end

  def app
    proc { [200, { 'Content-Type' => 'text/plain' }, ['Hello, World!']] }
  end
end
