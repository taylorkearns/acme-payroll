class Sales
	require 'csv'
	require_relative 'csv_reader'
	
	def initialize
		@csv_reader = CSVReader.new('sample_data.csv')
		@csv = @csv_reader.get_path
		@pay_period = 'weekly'
	end
	
	def period_sales_total
		total = 0.0
		CSV.foreach(@csv, headers: true) do |row|
			total += row['Sales This Period'].to_f
		end	
		total
	end
	
	def salary_this_period(salary)
		if @pay_period == 'weekly'
			salary/52
		elsif @pay_period == 'bi-weekly'
			salary/26
		elsif @pay_period == 'monthly'
			salary/12
		end
	end
end