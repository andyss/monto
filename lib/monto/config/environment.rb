# encoding: utf-8
module Monto
  module Config

    module Environment
      extend self

      def env_name
        return Rails.env if defined?(Rails)
        return Sinatra::Base.environment.to_s if defined?(Sinatra)
        ENV["RACK_ENV"] || ENV["MONTO_ENV"] || raise(Error::NoEnvironment.new)
      end

      def load_yaml(path, environment = nil)
        env = environment ? environment.to_s : env_name
        YAML.load(ERB.new(File.new(path).read).result)[env]
      end
    end
  end
end
