# return salary_payments, commission_payments, direct_deposit_payments, check_count
class Payroll
	require 'bigdecimal'
	require_relative 'csv_reader'
	require_relative 'employee'
	require_relative 'sales'
	
	def initialize(file_name)	
		@csv_reader = CSVReader.new(file_name)
		@csv_path = @csv_reader.get_path
		@bad_data = []
	end
	
	def payroll_report
		puts "==================================================\n\n"
		puts "::: PAYROLL REPORT :::"
		puts "Salary Payments This Period: $#{ salary_payments }"
		puts "Commission Payments This Period: $#{ commission_payments }"
		if @bad_data.count > 0	
			puts "\n\n>>> BAD DATA <<<\nThe following data must be corrected in order to calculate an accurate payroll report:\n\n"
			@bad_data.each do |data|
				puts "#{ data[:msg] }\n #{ data[:entry] }\n"
			end
		end
		puts "\n=================================================="
	end	
	
	def salary_payments
		payments = BigDecimal('0')
		paid_employees.each do |employee|
			payments += employee.salary_this_period
		end
		payments.round(2)
	end
	
	def commission_payments
		payments = BigDecimal('0')
		paid_employees.each do |employee|
			if employee.respond_to?('commission')
				payments += employee.commission
			end
		end
		payments
	end
	
	def paid_employees
		paid_employees = []
		CSV.foreach(@csv_path, headers: true) do |row|
			if paid_employee(row).class == NilClass
				bad_data(row, 'Incorrectly formatted employee data. Row is returning NilClass, which indicates data is missing or entered incorrectly.')
				next
			end
			paid_employees << paid_employee(row)
		end
		paid_employees
	end
	
	def paid_employee(row)
		position = row['Position']
		if position == 'Executive'
			employee = Executive.new(row['Last Name'], row['First Name'], row['Annual Salary'], row['Sales This Period'])
		elsif position == 'Manager'
			employee = Manager.new(row['Last Name'], row['First Name'], row['Annual Salary'], row['Sales This Period'])
		elsif position == 'Sales'
			employee = Salesperson.new(row['Last Name'], row['First Name'], row['Annual Salary'], row['Sales This Period'])
		elsif position == 'Engineer'
			employee = Engineer.new(row['Last Name'], row['First Name'], row['Annual Salary'], row['Sales This Period'])
		end
		employee
	end	
	
	def bad_data(row, msg)
		@bad_data << { :entry => row, :msg => msg}
	end
end

payroll = Payroll.new('sample_data_corrected.csv')
payroll.payroll_report

