class Employee
	require 'bigdecimal'
	
	def initialize last_name, first_name
		@last_name = last_name.capitalize
		@first_name = first_name.capitalize
	end
end

class Executive < Employee
	require_relative 'sales'
	
	attr_reader :salary_this_period, :commission_this_period, :pay_type, :pay_period 

	def initialize last_name, first_name, salary, period_sales
		@last_name = last_name.capitalize
		@first_name = first_name.capitalize
		@salary = BigDecimal(salary)
		@sales = Sales.new
		@salary_this_period = @sales.salary_this_period(@salary)
		@period_sales = 0
		@position = 'executive'
		@period_sales_total = @sales.period_sales_total
		@commission_this_period = 0.02 * @period_sales_total
		@pay_period = 'monthly'
		@pay_type = 'direct_deposit'
	end
end

class Manager < Employee
	require_relative 'sales'
	
	attr_reader :salary_this_period, :commission_this_period, :pay_type, :pay_period

	def initialize last_name, first_name, salary, period_sales
		@last_name = last_name.capitalize
		@first_name = first_name.capitalize
		@salary = BigDecimal(salary)
		@sales = Sales.new
		@salary_this_period = @sales.salary_this_period(@salary)
		@period_sales = 0
		@position = 'manager'
		@commission_this_period = 0
		@pay_period = 'bi-weekly'
		@pay_type = 'direct_deposit'
	end
end

class Salesperson < Employee
	require_relative 'sales'
	
	attr_reader :salary_this_period, :commission_this_period, :pay_type, :pay_period
	
	def initialize last_name, first_name, salary, period_sales
		@last_name = last_name.capitalize
		@first_name = first_name.capitalize
		@salary = 0
		@sales = Sales.new
		@salary_this_period = @sales.salary_this_period(@salary)
		@period_sales = BigDecimal(period_sales)
		@position = 'sales'
		@commission_this_period = @period_sales >= 15000.00 ? 0.20 * @period_sales : 0
		@pay_period = 'weekly'
		@pay_type = 'check'
	end
end

class Engineer < Employee
	require_relative 'sales'
	
	attr_reader :salary_this_period, :commission_this_period, :pay_type, :pay_period

	def initialize last_name, first_name, salary, period_sales
		@last_name = last_name.capitalize
		@first_name = first_name.capitalize
		@salary = BigDecimal(salary)
		@sales = Sales.new
		@salary_this_period = @sales.salary_this_period(@salary)
		@period_sales = 0
		@position = 'engineer'
		@commission_this_period = 0
		@pay_period = 'monthly'
		@pay_type = 'direct_deposit'
	end
end


 