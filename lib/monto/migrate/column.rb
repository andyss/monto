module Monto
  module Migrate
    module Column
      extend Concernable
      
      included do
        add_column :_id
      end
            
      module ClassMethods
        def add_column(name, options = {})
          create_column_getter(name)
          create_column_setter(name)
        end

        def create_column_getter(name)
          re_define_method(name) do
            value = read_attribute(name)
            value
          end
        end

        def create_column_setter(name)
          re_define_method("#{name}=") do |value|
            val = write_attribute(name, value)
            val
          end
        end
      end      
    end
  end
end