# encoding: utf-8
module Monto
  module Session
    class MongoUri

      SCHEME = /(mongodb:\/\/)/
      USER = /([-.\w:]+)/
      PASS = /([^@,]+)/
      NODES = /((([-.\w]+)(?::(\w+))?,?)+)/
      DATABASE = /(?:\/([-\w]+))?/

      URI = /#{SCHEME}(#{USER}:#{PASS}@)?#{NODES}#{DATABASE}/

      attr_reader :match

      def database
        @database ||= match[9]
      end

      def hosts
        @hosts ||= match[5].split(",")
      end

      def initialize(string)
        @match = string.match(URI)
      end

      def password
        @password ||= match[4]
      end

      def to_hash
        config = { database: database, hosts: hosts }
        if username && password
          config.merge!(username: username, password: password)
        end
        config
      end

      def username
        @username ||= match[3]
      end
    end
  end
end
