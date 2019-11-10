require_relative "../config/environment.rb"
require 'active_support/inflector'
require 'pry-nav'

class InteractiveRecord

	def self.table_name	
		self.to_s.downcase.pluralize
	end

	def self.column_names
		DB[:conn].results_as_hash = true
		sql = "pragma table_info('#{table_name}')"
		columns = DB[:conn].execute(sql)
		column_names = []
		columns.each do |col|
			column_names << col["name"]
		end	
		column_names	
	end

	def table_name_for_insert
		self.class.table_name
	end

	def col_names_for_insert
		self.class.column_names.delete_if {|col| col == "id"}.join(", ")
	end

	def values_for_insert
	    values = []
	    self.class.column_names.each do |col_name|
	      values << "'#{send(col_name)}'" unless send(col_name).nil?
	    end
	    values.join(", ")
	end

  	def save
  		sql = "INSERT INTO #{table_name_for_insert} (#{col_names_for_insert}) VALUES (#{values_for_insert})"
  		DB[:conn].execute(sql)
  		@id = DB[:conn].execute("SELECT last_insert_rowid() FROM #{table_name_for_insert}")[0][0]
  	end

  	def self.find_by_name(name)
  		sql = "SELECT * FROM #{self.table_name} WHERE name = '#{name}'"
  		DB[:conn].execute(sql)
 	end

 	 def self.find_by(attribute)
    	attribute_key = attribute.keys.join()
   	    attrubute_value = attribute.values.first
   		sql =<<-SQL
      		SELECT * FROM #{self.table_name}
      		WHERE #{attribute_key} = "#{attrubute_value}"
      		LIMIT 1
    	SQL
    	row = DB[:conn].execute(sql)
    end
end

