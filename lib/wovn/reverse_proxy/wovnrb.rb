require 'wovnrb'

module Wovn
  module ReverseProxy
    # Fixed Wovnrb for reverse proxy.
    class Wovnrb < Wovnrb::Interceptor
      def initialize(app, opts = {})
        super
        @setting_keys = @store.instance_eval { @settings.keys }
      end

      def call(env)
        opts = get_wovn_settings(env)
        @store.reset
        @store.settings(opts)
        super
      end

      private

      def get_wovn_settings(env)
        @setting_keys.each_with_object({}) do |key, params|
          env_key = "HTTP_X_WOVN_#{key.upcase}"
          value = env[env_key]
          next unless value
          params[key] = get_appropriate_value(key, value)
        end
      end

      def get_appropriate_value(key, value)
        if key == 'query' || key == 'supported_langs'
          value = value.split(/,/)
        elsif key == 'test_mode' || key == 'use_proxy'
          value = true? value
        end
        value
      end

      def true?(value)
        return true if value.to_s.casecmp('true').zero?
        return true if value.to_s.casecmp('on').zero?
        return true if value.to_s == '1'
        false
      end
    end
  end
end
