require_relative "../config/environment.rb"
require 'active_support/inflector'
require 'interactive_record.rb'
require 'pry-nav'

class Student < InteractiveRecord

	self.column_names.each do |attributes|
		attr_accessor attributes.to_sym
		end   

	def initialize(attributes_hash={})
		attributes_hash.each_pair do |key, value|
		self.send("#{key}=", value)
    	end
	end
		
end
