require 'net/http'
require 'minitest/autorun'

class ShippingProvider
	attr_accessor :url
	
	def initialize (params {})
	
	end
	
end

class ShippingFee
	attr_accessor :provider, :origin, :destination, :fees
	
	def initialize(shipping_provider)
		@sp = shipping_provider
	end
	
end

class EstafetaShippingProvider < ShippingProvider
	attr_reader :result_html
	
	def initialize(values = {})
		@to = values[:to]
		@from = values[:from]
		@type = values[:type]
		@package = values[:package]
		@weight = values[:weight]
		@height = values[:height]
		@width = values[:width]
		@deep = values[:deep]
		
		uri = URI('http://rastreo2.estafeta.com:7001/Tarificador/admin/TarificadorAction.do?dispatch=doGetTarifas')
		#params = { :limit => 10, :page => 3 }
		uri.query = URI.encode_www_form(params)
		@result_html = Net::HTTP.get(uri)
	end
	
	def format
		return result_html
	end
end

# Data to run the program
esp = EstafetaShippingProvider.new(to: 22510, from: 22500, type: package:, weight: 0, height: 0, width: 0, deep: 0)
esp.format