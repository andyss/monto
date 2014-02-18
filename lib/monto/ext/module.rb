# encoding: utf-8
module Monto
  module Ext
    module Module
      def re_define_method(name, &block)
        undef_method(name) if method_defined?(name)
        define_method(name, &block)
      end
    end
  end
end

::Module.__send__(:include, Monto::Ext::Module)
