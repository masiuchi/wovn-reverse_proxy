require 'minitest/autorun'
require 'wovn/reverse_proxy/rack_reverse_proxy'

describe Wovn::ReverseProxy::RackReverseProxy do
  it 'inherits Rack::ReverseProxy' do
    Wovn::ReverseProxy::RackReverseProxy.superclass.must_equal \
      Rack::ReverseProxy
  end
end
