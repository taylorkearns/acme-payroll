class Employee
	require 'bigdecimal'
	require './lib/sales'
	
	attr_accessor :salary_this_period, :pay_type
	
	def initialize(last_name, first_name, salary, period_sales)
		self.last_name = last_name
		self.first_name = first_name
		self.salary = salary
		self.period_sales = period_sales
		@position = self.class.name
		@sales = Sales.new
	end	

	def last_name=(name)
		@last_name = name.capitalize
	end
	
	def first_name=(name)
		@first_name = name.capitalize
	end
	
	def salary=(amt)
		@salary = BigDecimal(amt)
	end
	
	def period_sales=(amt)
		@period_sales = BigDecimal(amt)
	end
	
	def pay_period
		'monthly'
	end
	
	def salary_this_period
		@salary.div(13)
	end
	
	def commission_this_period
		0
	end
end

class Executive < Employee
	def initialize last_name, first_name, salary, period_sales
		super(last_name, first_name, salary, period_sales)
		@period_sales_total = @sales.period_sales_total
		@pay_type = 'direct_deposit'
	end
	
	def commission_this_period
		0.02 * @period_sales_total
	end
end

class Engineer < Employee
	def initialize last_name, first_name, salary, period_sales
		super(last_name, first_name, salary, period_sales)
		@sales = Sales.new
		@commission_this_period = 0
		@pay_type = 'direct_deposit'
	end
end

class Manager < Employee
	def initialize last_name, first_name, salary, period_sales
		super(last_name, first_name, salary, period_sales)
		@pay_type = 'direct_deposit'
	end
	
	def pay_period
		'bi-weekly'
	end
	
	def salary_this_period
		@salary.div(26)
	end
end

class Salesperson < Employee
	def initialize last_name, first_name, salary, period_sales
		super(last_name, first_name, salary, period_sales)
		@pay_type = 'check'
	end
	
	def pay_period
		'weekly'
	end
	
	def salary_this_period
		@salary.div(52)
	end
	
	def commission_this_period
		@period_sales >= 15000.00 ? 0.20 * @period_sales : 0
	end
end
 