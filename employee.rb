class Employee
	require 'bigdecimal'
	
	def initialize last_name, first_name
		@last_name = last_name.capitalize
		@first_name = first_name.capitalize
	end
end

class Executive < Employee
	require_relative 'sales'
	
	attr_reader :salary_this_period

	def initialize last_name, first_name, salary, period_sales
		@last_name = last_name.capitalize
		@first_name = first_name.capitalize
		@salary = salary.to_f
		@sales = Sales.new
		@period_sales = 0
		@position = 'executive'
		@period_sales_total = @sales.period_sales_total
		@commission = BigDecimal('commission')
		@pay_period = 'monthly'
		@pay_type = 'direct_deposit'
	end
	
	def salary_this_period
		@sales.salary_this_period(@salary)
	end
	
	def commission
		0.02 * @period_sales_total	
	end
end

class Manager < Employee
	require_relative 'sales'
	
	attr_reader :salary_this_period

	def initialize last_name, first_name, salary, period_sales
		@last_name = last_name.capitalize
		@first_name = first_name.capitalize
		@salary = salary.to_f
		@sales = Sales.new
		@period_sales = 0
		@position = 'manager'
		@commission = 0
		@pay_period = 'bi-weekly'
		@pay_type = 'direct_deposit'
	end
	
	def salary_this_period
		@sales.salary_this_period(@salary)
	end
end

class Salesperson < Employee
	require_relative 'sales'
	
	attr_reader :salary_this_period
	
	def initialize last_name, first_name, salary, period_sales
		@last_name = last_name.capitalize
		@first_name = first_name.capitalize
		@salary = 0
		@sales = Sales.new
		@period_sales = period_sales.to_f
		@position = 'sales'
		@commission = BigDecimal('commission') 
		@pay_period = 'weekly'
		@pay_type = 'check'
	end
	
	def salary_this_period
		@sales.salary_this_period(@salary)
	end
	
	def commission
		if @period_sales >= 15000.00 
			0.20 * @period_sales
		else
			0
		end
	end
end

class Engineer < Employee
	require_relative 'sales'
	
	attr_reader :salary_this_period

	def initialize last_name, first_name, salary, period_sales
		@last_name = last_name.capitalize
		@first_name = first_name.capitalize
		@salary = salary.to_f
		@sales = Sales.new
		@period_sales = 0
		@position = 'engineer'
		@commission = 0
		@pay_period = 'monthly'
		@pay_type = 'direct_deposit'
	end
	
	def salary_this_period
		@sales.salary_this_period(@salary)
	end
end


 