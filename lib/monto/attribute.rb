module Monto
  module Attribute
    attr_reader :attributes
    alias :raw_attributes :attributes
    
    def attributes
      @attributes ||= {}
    end
        
    def read_attribute(name)
      normalized = name.to_s
      # if attribute_missing?(name)
      #   raise ActiveModel::MissingAttributeError, "Missing attribute: '#{name}'."
      # end
      # if hash_dot_syntax?(normalized)
      #   attributes.__nested__(normalized)
      # else
        attributes[normalized]
      # end
    end
    alias :[] :read_attribute
    
    
    def write_attribute(name, value)
      access = name.to_s
      # if attribute_writable?(access)
        _assigning do
          # validate_attribute_value(access, value)
          # localized = fields[access].try(:localized?)
          # attributes_before_type_cast[name.to_s] = value
          # typed_value = typed_value_for(access, value)
          # unless attributes[access] == typed_value || attribute_changed?(access)
            # attribute_will_change!(access)
          # end
          # if localized
            # (attributes[access] ||= {}).merge!(typed_value)
          # else
            attributes[access] = value
          # end
          access
        end
      # end
    end
    alias :[]= :write_attribute
    
  end
end