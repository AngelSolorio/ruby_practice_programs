class Product
	include AttributesInitializer
	
	attr_accessor :name, :description 
	attr_reader :tax
	
	def initialize(attrs = {})
		@name = attrs [:name]
		@description = attrs [:description]
	end
 
	def total_price
		(@price * @tax) + @price
	end
end

class Game < Product
	attr_accessor :rate
	
	def initialize(attrs = {})
		super attrs
		@rate = attrs[:rate]
	end
end

class Plane
	include AttributesInitializer
	include NicePrint
	
	attr_accessor :description, :capacity
	
	def initialize(attr ={})
		load_attributes attrs
	end
	
	def get_values
		puts "description: #{description}\n capacity: #{capacity}"
	end
end

module NicePrint
	def print
		puts "******* #{self.class.name} ******"
		puts "#{get_values}"
		puts "****************************"
	end
	
	def get_values
		"Override me"
	end
end

module AboutMe
	def me
		puts self.class.name
	end
end

module AttributesInitializer
	def print
		puts "Nothing to show"
	end
	
	def load_attributes(attrs = {})
		attrs.keys.each do |key|
			if respond_to?("#{key.to_s}")
				send("#{key.to_s}=", attrs[:key])
			else
				#clas_eval {attr_accessor key}
				#send("#{key.to_s}=" attrs[key])
			end
		end
		@name = attrs[:name]
		@price = attrs[:price] || 0
	end
end 

#####################
class test
	def time
		start = Time.now
		puts "Starting..."
		result = yield if block_given?
		puts "Completed #{Time.now - start}"
		result
	end
	
	def return_proc
		p = Proc.new {return "Hey!"}
		p.call
		return 'We are at the end'
	end
	
	def return_lambda
		l = lambda {return 'Hey!'}
		l.call
		return 'We are at the end'
	end
end