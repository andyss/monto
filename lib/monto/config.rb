# encoding: utf-8
require "monto/config/environment"
require "monto/config/option"

module Monto

  # This module defines all the configuration options for Monto, including the
  # database connections.
  module Config
    extend self
    extend Option

    LOCK = Mutex.new

    # option :include_root_in_json, default: false
    # option :include_type_for_serialization, default: false
    # option :preload_models, default: false
    # option :raise_not_found_error, default: true
    # option :scope_overwrite_exception, default: false
    # option :duplicate_fields_exception, default: false
    # option :use_activesupport_time_zone, default: true
    # option :use_utc, default: false

    def configured?
      sessions.has_key?(:default)
    end

    def connect_to(name, options = { read: :primary })
      self.sessions = {
        default: {
          database: name,
          host: "localhost",
          port: 27017,
          options: options
        }
      }.with_indifferent_access
    end

    def destructive_fields
      Composable.prohibited_methods
    end

    def load!(path, environment = nil)
      settings = Environment.load_yaml(path, environment)
      if settings.present?
        Session.disconnect
        Session.clear
        load_configuration(settings)
      end
      settings
    end

    def models
      @models ||= []
    end

    def register_model(klass)
      LOCK.synchronize do
        models.push(klass) unless models.include?(klass)
      end
    end

    def load_configuration(settings)
      configuration = settings.with_indifferent_access
      self.options = configuration[:options]
      self.sessions = configuration[:sessions]
    end

    def override_database(name)
      Threaded.database_override = name
    end

    def override_session(name)
      Threaded.session_override = name ? name.to_s : nil
    end

    def purge!
      Session.default.collections.each do |collection|
        collection.drop
      end and true
    end

    def truncate!
      Session.default.collections.each do |collection|
        collection.find.remove_all
      end and true
    end

    def options=(options)
      if options
        options.each_pair do |option, value|
          send("#{option}=", value)
        end
      end
    end

    def sessions
      @sessions ||= {}
    end

    def sessions=(sessions)
      raise Error::NoSessionConfig.new unless sessions
      sess = sessions.with_indifferent_access
      @sessions = sess
      sess
    end

    def time_zone
      use_utc? ? "UTC" : ::Time.zone
    end

    def running_with_passenger?
      @running_with_passenger ||= defined?(PhusionPassenger)
    end
  end
end
