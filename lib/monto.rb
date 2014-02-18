$: << File.join(Dir.pwd)

require "monto/concernable"
require "monto/ext/delegation"
require "monto/ext/hash/indifferent_access"
require "monto/ext/extract_options"
require "monto/ext/attribute_accessors"
require "monto/ext/try"

require "mongo"

require "monto/session"
require "monto/config"
require "monto/error"

require "monto/base"

module Monto
  extend self
  
  def configure
    block_given? ? yield(Config) : Config
  end

  def default_session
    Session.default
  end

  def disconnect_sessions
    Session.disconnect
  end

  def session(name)
    Session.with_name(name)
  end

  delegate(*(Config.public_instance_methods(false) - [ :logger=, :logger ] << { to: Config }))
end



