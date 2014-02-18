module Monto
  module Findable
    extend Concernable

    module ClassMethods
      def all
        collection.find().map do |doc|
          self.new(doc)
        end
      end
      
      def delete_all
        collection.remove()
      end
      alias :remove_all :delete_all
      
      def find(object_id)
        collection.find_one({:_id => object_id})
      end

      def first
        document = collection.find_one()
        self.new(document)
      end

      def last
        document = collection.find({}, {:limit => -1, :sort => {:_id => Mongo::DESCENDING}}).next_document
        self.new(document)
      end

      def find_by(h = {})
        document = collection.find(h).next_document
        self.new(document)
      end

      def where(h = {})
        collection.find(h).each do |doc|
          self.new(doc)
        end
      end
    end
  end
end