# encoding: utf-8
require "monto/session/mongo_uri"

module Monto
  module Session
    module Factory
      extend self

      def create(name = nil)
        return default unless name
        config = Monto.sessions[name]
        raise Error.new(name) unless config
        create_session(config)
      end

      def default
        create_session(Monto.sessions[:default])
      end

      private

      def create_session(configuration)
        raise Error.new unless configuration
        config, options = parse(configuration)
        configuration.merge!(config) if configuration.delete(:uri)

        # options[:instrumenter] = Monto::Notifications
        session = Mongo::MongoClient.new(config[:host], config[:port])
        # session.use(config[:database])
        # if authenticated?(config)
        #   session.login(config[:username], config[:password])
        # end
        session
      end

      # def authenticated?(config)
      #   config.has_key?(:username) && config.has_key?(:password)
      # end

      def parse(config)
        options = config[:options].try(:dup) || {}
        parsed = if config.has_key?(:uri)
          MongoUri.new(config[:uri]).to_hash
        else
          config
          # inject_ports(config)
        end
        [ parsed, options.symbolize_keys ]
      end

      # def inject_ports(config)
      #   config["hosts"] = config["hosts"].map do |host|
      #     host =~ /:/ ? host : "#{host}:27017"
      #   end
      #   config
      # end
    end
  end
end
