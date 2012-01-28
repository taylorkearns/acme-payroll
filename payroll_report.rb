# TO DO: 
# Add testing
# Add error handling using raise and rescue


# returns salary_payments, commission_payments, direct_deposit_payments, check_count
class Payroll
	require 'csv'
	require 'bigdecimal'
	require './lib/csv_reader'
	require './lib/employee'
	
	def initialize
		puts "--------------------------------------------------\n\n"
		puts "Enter file name (file must be in the 'data' directory):"
		@file_name = gets.chomp!
		@csv_path = Dir.getwd + '/data/' + @file_name
		@bad_data = []
		puts "Enter the week (1-4) of the month:"
		@pay_week = gets.chomp!.to_i 
	end
	
	def payroll_report
		sal_pay = payments[:salary_payments]
		comm_pay = payments[:commission_payments]
		dd_pay = payments[:direct_deposit_payments]
		ch_pay = payments[:check_payments]
		ch_count = payments[:checks_written]
		
		puts "="*50+"\n\n"
		puts "::: PAYROLL REPORT :::"
		puts "Salary Payments This Period: $#{ sprintf('%.2f', sal_pay) }"
		puts "Commission Payments This Period: $#{ sprintf('%.2f', comm_pay) }"
		puts "Direct Deposit Payments This Period: $#{ sprintf('%.2f', dd_pay) }"
		puts "Check Payments This Period: $#{ sprintf('%.2f', ch_pay) }"
		puts "Checks Written This Period: #{ ch_count }"
		puts "Total Payments This Period: $#{ sprintf('%.2f', sal_pay + comm_pay) }"
		
		if @bad_data.count > 0	
			puts "\n\n>>> BAD DATA <<<\nThe following data must be corrected in order to calculate an accurate payroll report:\n\n"
			@bad_data.each do |data|
				puts "#{ data[:msg] }\n #{ data[:entry] }\n"
			end
		end
		
		puts "\n"+"="*50+"\n\n"
	end	
	
	def payments
		salary_payments = BigDecimal.new('0')
		commission_payments = BigDecimal.new('0')
		direct_deposit_payments = BigDecimal.new('0')
		check_payments = BigDecimal.new('0')
		checks_written = 0
	
		paid_employees.each do |employee|
			salary_payments += employee.salary_this_period
			commission_payments += employee.commission_this_period
			if employee.pay_type === 'direct_deposit'
				direct_deposit_payments += (employee.salary_this_period + employee.commission_this_period)
			elsif employee.pay_type === 'check'
				check_payments += employee.commission_this_period
				checks_written += 1
			end
		end
		{
			:salary_payments => salary_payments, 
			:commission_payments => commission_payments, 
			:direct_deposit_payments => direct_deposit_payments, 
			:check_payments => check_payments, 
			:checks_written => checks_written
		}
	end
		
	def paid_employees
		paid_employees = []
		CSV.foreach(@csv_path, headers: true) do |row|
			position = row['Position']
			if position == 'Executive' && @pay_week == 3
				employee = Executive.new(row['Last Name'], row['First Name'], row['Annual Salary'], row['Sales This Period'])
			elsif position == 'Manager' && (@pay_week == 1 || @pay_week == 3)
				employee = Manager.new(row['Last Name'], row['First Name'], row['Annual Salary'], row['Sales This Period'])
			elsif position == 'Sales'
				employee = Salesperson.new(row['Last Name'], row['First Name'], row['Annual Salary'], row['Sales This Period'])
			elsif position == 'Engineer' && @pay_week == 3
				employee = Engineer.new(row['Last Name'], row['First Name'], row['Annual Salary'], row['Sales This Pe<%  %>iod'])
			else
				next
			end
			paid_employees << employee
		end
		paid_employees
	end
		
	def bad_data(row, msg)
		@bad_data << { :entry => row, :msg => msg}
	end	
end

payroll = Payroll.new
payroll.payroll_report

