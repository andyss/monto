$: << File.join(Dir.pwd)
require "monto"

Monto.configure.connect_to("mongoid_test")

# require "active_record"
# 
# ActiveRecord::Base.establish_connection(
#   adapter:  'mysql2',
#   database: 'g2-server_development',
#   username: 'root',
#   password: '',
#   host:     'localhost'
# )


class Test
  include Monto::Base
    
  add_column :a
  add_column :b
                      
end

t = Test.new
t.a = "test2"
t.save

t = Test.first
p t.a
p t._id

p Test.all

Test.delete_all

# Test.all.each do |x|
#   p x
# end
# p t


# class User
#   include Monto::Base
#   
#   add_column :a
#   add_column :b
#   
# end
# 
# u = User.new
# u.b = "test1"
# p u.collection
# u.save

# u = User.first
# u.a = "test"
# u.save
# 
# p u.a
# p u

# t = Test.new
# p t.db
# p t.collection
# t.a = "test"
# t.b = "haha"
# t.save
