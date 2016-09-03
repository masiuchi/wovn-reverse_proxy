require 'rack/reverse_proxy'

module Wovn
  module ReverseProxy
    # Rack::ReverseProxy for wovn-reverse_proxy.
    class RackReverseProxy < Rack::ReverseProxy
      def call(env)
        host = env['HTTP_X_WOVN_HOST'] || env['HTTP_HOST']
        return invalid_host if host.nil? || host.empty?

        @rules = []
        reverse_proxy '/', host
        super
      end

      private

      def invalid_host
        [400, { 'Content-Type' => 'text/plain' }, ['Invalid host parameter.']]
      end
    end
  end
end
