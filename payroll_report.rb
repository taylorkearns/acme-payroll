# returns salary_payments, commission_payments, direct_deposit_payments, check_count
# 19, 33, 46
class Payroll
	require 'bigdecimal'
	require_relative 'csv_reader'
	require_relative 'employee'
	require_relative 'sales'
	
	def initialize(file_name)	
		@csv_reader = CSVReader.new(file_name)
		@csv_path = @csv_reader.get_path
		@bad_data = []
		# choose either 1, 2, 3, or 4 for week of the month. 3 means third Friday of the month.
		@pay_week = 3 
	end
	
	def payroll_report
		# store salary and commission payments in a variable for re-use and arithmetic
		sal_pay = salary_payments
		comm_pay = commission_payments
		dd_pay = direct_deposit_payments
		ch_pay = check_payments
		ch_count = checks_written
		puts "==================================================\n\n"
		puts "::: PAYROLL REPORT :::"
		puts "Salary Payments This Period: $#{ sal_pay }"
		puts "Commission Payments This Period: $#{ comm_pay }"
		puts "Direct Deposit Payments This Period: $#{ dd_pay }"
		puts "Check Payments This Period: $#{ ch_pay }"
		puts "Checks Written This Period: #{ ch_count }"
		if sal_pay + comm_pay == dd_pay + ch_pay
			puts "Total Payments This Period: $#{ sal_pay + comm_pay  }"
		else
			puts "Salary + commission payments do not equal direct deposit + check payments. Please check the program code."
		end
		if @bad_data.count > 0	
			puts "\n\n>>> BAD DATA <<<\nThe following data must be corrected in order to calculate an accurate payroll report:\n\n"
			@bad_data.each do |data|
				puts "#{ data[:msg] }\n #{ data[:entry] }\n"
			end
		end
		puts "\n=================================================="
	end	
	
	def salary_payments
		payments = 0
		paid_employees.each do |employee|
			payments += employee.salary_this_period
		end
		payments
	end
	
	def commission_payments
		payments = 0
		paid_employees.each do |employee|
			if employee.respond_to?('commission_this_period')
				payments += employee.commission_this_period
			end
		end
		payments.round(2)
	end
	
	def direct_deposit_payments
		payments = 0
		paid_employees.each do |employee|
			if employee.pay_type === 'direct_deposit'
				payments += (employee.salary_this_period + employee.commission_this_period)
			end
		end
		payments.round(2)
	end
	
	def check_payments
		payments = 0
		paid_employees.each do |employee|
			if employee.pay_type === 'check'
				payments += employee.commission_this_period
			end
		end
		payments.round(2)
	end
	
	def checks_written
		checks_count = 0
		paid_employees.each do |employee|
			if employee.pay_type === 'check'
				checks_count += 1
			end
		end
		checks_count
	end
	
	def paid_employees
		paid_employees = []
		CSV.foreach(@csv_path, headers: true) do |row|
			if paid_employee(row).class == NilClass
				bad_data(row, 'Incorrectly formatted employee data. Row is returning NilClass, which indicates data is missing or entered incorrectly.')
				next
			end
			paid_employees << paid_employee(row) if paid_employee(row)
		end
		paid_employees
	end
	
	def paid_employee(row)
		position = row['Position']
		if position == 'Executive' && @pay_week == 3
			employee = Executive.new(row['Last Name'], row['First Name'], row['Annual Salary'], row['Sales This Period'])
		elsif position == 'Manager' && (@pay_week == 1 || @pay_week == 3)
			employee = Manager.new(row['Last Name'], row['First Name'], row['Annual Salary'], row['Sales This Period'])
		elsif position == 'Sales'
			employee = Salesperson.new(row['Last Name'], row['First Name'], row['Annual Salary'], row['Sales This Period'])
		elsif position == 'Engineer' && @pay_week == 3
			employee = Engineer.new(row['Last Name'], row['First Name'], row['Annual Salary'], row['Sales This Period'])
		else
			employee = false
		end
		employee
	end	
	
	def bad_data(row, msg)
		@bad_data << { :entry => row, :msg => msg}
	end
end

payroll = Payroll.new('sample_data_corrected.csv')
payroll.payroll_report

