require 'rack/reverse_proxy'

module Wovn
  module ReverseProxy
    # Rack::ReverseProxy for wovn-reverse_proxy.
    class RackReverseProxy < Rack::ReverseProxy
      def call(env)
        host = env['HTTP_X_WOVN_HOST'] || env['HTTP_HOST']
        host = host.to_s
        return invalid_host if host.empty?

        env['SERVER_NAME'] = env['HTTP_HOST'] = env['HTTP_X_FORWARDED_HOST']

        @rules = []
        reverse_proxy '/', host
        reverse_proxy_options preserve_host: false

        status, headers, body = super
        [status, headers, [body.to_s]]
      end

      private

      def invalid_host
        [400, { 'Content-Type' => 'text/plain' }, ['Invalid host parameter.']]
      end
    end
  end
end
