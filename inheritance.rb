class Employee
  attr_accessor :name, :title, :salary, :boss

  def initialize(name, title, salary)
    @name, @title, @salary = name, title, salary
  end

  def calculate_bonus(multiplier)
    salary * multiplier
  end

  protected

  def salary_for_bonus
    salary
  end

end

class Manager < Employee
  attr_accessor :underlings

  def initialize(name, title, salary)
    super(name, title, salary)
    @underlings = []
  end

  def calculate_bonus(multiplier)
    total_underling_salary = underlings.map do |underling|
      underling.salary_for_bonus
    end

    multiplier * total_underling_salary.inject(0, :+)

  end


  def assign_new_employee(employee)
    underlings << employee unless underlings.include?(employee)
    employee.boss = self
  end

  protected

  def salary_for_bonus
    salary + underlings.map { |underling| underling.salary_for_bonus }.inject(0, :+)
  end

end
=begin
emp1 = Employee.new('a', 't1', 5000)
ceo = Manager.new('big_ceo_guy', 'ceo', 100000)
man1 = Manager.new('man1', 'Mt1', 50000)
man2 = Manager.new('man2', 'Mt2', 45000)

ceo.assign_new_employee(man1)
ceo.assign_new_employee(man2)
ceo.assign_new_employee(emp1)



emps = []
5.times do |i|
  emps << Employee.new((97 + i).chr, 't#{i}', i * 1000)
end

emps.each { |emp| man1.assign_new_employee(emp) }

puts ceo.calculate_bonus(2)

=end