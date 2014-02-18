module Monto
  module Stateable
    attr_writer :new_record
    
    def new_record?
      @new_record ||= false
    end
  end
end