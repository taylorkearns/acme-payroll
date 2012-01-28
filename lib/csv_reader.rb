class CSVReader
	require 'csv'
	
	def initialize(csv)
		@csv = csv
	end
	
	def get_path
		Dir.getwd + '/data/' + @csv
	end
end