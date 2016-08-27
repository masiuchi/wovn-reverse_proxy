require 'net/http'
require 'sinatra/base'
require 'uri'
require 'wovn/reverse_proxy/wovnrb'

module Wovn
  module ReverseProxy
    # Reverse proxy implemented by Sinatra.
    class Application < Sinatra::Base
      use Wovn::ReverseProxy::Wovnrb

      get '*' do
        # Get url parameter.
        host = env['HTTP_X_WOVN_HOST']

        # Check url parameter.
        if host.nil? || host.empty?
          status 400
          return 'Invalid host parameter.'
        end

        # Generate URL of original content.
        request_uri = env['REQUEST_URI']
        request_uri.sub!(%r{^https?://[^/]+/}, '/')
        uri = URI.parse(host + request_uri)

        # Retrieve original content.
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true if uri.scheme == 'https'
        res = http.start { http.get(uri.request_uri) }

        # Pass original content to wovnrb.
        status       res.code
        content_type res.content_type
        res.body
      end

      run! if app_file == $PROGRAM_NAME
    end
  end
end
