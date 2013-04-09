# Para ejecutar el codigo es con:
# $ ruby temperature.rb

# Matchers de minitest 
# http://www.mattsears.com/articles/2011/12/10/minitest-quick-reference

# Write a class that can convert from Celsius to Fahrenheit
# Example:
# t = Temperature.in_celsius(24)
# t.to_far
# => 68
# t = Temperature.in_far(68)
# t.to_cel
# => 24

require 'minitest/autorun'

class Temperature
  attr_reader :value, :kind

  def initialize(value, kind)
    @value = value
    @kind = kind
  end

  def self.in_celsius(value)
    Temperature.new value.to_f, :celsius
  end

  def self.in_fahrenheit(value)
    Temperature.new value.to_f, :fahrenheit
  end
end

describe Temperature do

  describe "Convertion" do
    it "Converts from Fahrenheit to Celsius" do
      temperature = Temperature.in_fahrenheit(10)

      temperature.to_cel.must_equal -12.2222
    end
    
    it "Converts from Celsius to Fahrenheit" do
      temperature = Temperature.in_celsius(10)

      temperature.to_far.must_be_close_to 50
    end
  
    it "Converts from Fahrenheit to Fahrenheit" do
      temperature = Temperature.in_fahrenheit(10)

      temperature.to_far.must_equal 10
    end
    
    it "Converts from Celsius to Celsius" do
      temperature = Temperature.in_celsius(10)

      temperature.to_cel.must_equal 10
    end
  end

  describe "Instantiation" do
    it "could be instantiate in celsius" do
      temperature = Temperature.in_celsius(10)

      temperature.wont_be_nil
    end

    it "could be instantiate in fahrenheit" do
      temperature = Temperature.in_fahrenheit(10)

      temperature.wont_be_nil
    end

    it "must be 10f" do
      temperature = Temperature.in_fahrenheit(10)

      temperature.value.must_equal 10.0
      temperature.kind.must_equal :fahrenheit
    end

    it "must be 20c" do
      temperature = Temperature.in_celsius(20)

      temperature.value.must_equal 20.0
      temperature.kind.must_equal :celsius
    end
  end

end
