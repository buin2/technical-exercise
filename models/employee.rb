#!/usr/bin/env ruby

class Employee
  attr_reader :employee_id, :name

  def initialize(employee_id:, name:)
    @employee_id = employee_id
    @name = name
  end

  def to_data_array
    [employee_id, name]
  end

end