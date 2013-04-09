module AttributesInitializer
  def print
    puts "Nothing to show"
  end
  
  def load_attributes(attrs = {})
    attrs.keys.each do |key|
      unless respond_to?("#{key.to_s}=")
        instance_eval "def #{key.to_s}=(value);@#{key.to_s} = value;end;def #{key.to_s};@#{key.to_s};end"
      end
        
      send("#{key.to_s}=", attrs[key])
      
      #puts self.instance_variables.inspect
    end
  end
end
 
module NicePrint
  def print
    puts "******** #{self.class.name} ********"
    "#{get_values}"
    puts "***********************"
  end
  
  def get_values
    self.instance_variables.each do |nameatt|
    	puts "#{nameatt.to_s}: #{self.instance_variable_get(nameatt)} "
    end
  end
end
 
module AboutMe
  def me
    puts self.class.name
  end
end
 
 
class Product
  include AttributesInitializer
  include NicePrint
  
  attr_accessor :name, :price
  attr_reader :tax
  
  def initialize(attrs = {})
    load_attributes attrs
    @tax = 0.16
  end
  
  def total_price
    (@price * @tax) + @price
  end
end
 
class Game < Product
  attr_accessor :rate
end
 
class Plane
  include AttributesInitializer
  include NicePrint
  
  attr_accessor :description, :capacity
  
  def initialize(attrs = {})
    load_attributes attrs
  end
  
end

p = Plane.new description:'Boeing 747', capacity:'500 people', cost:1000000
p.print