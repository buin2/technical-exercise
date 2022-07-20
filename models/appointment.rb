#!/usr/bin/env ruby

require 'date'

class Appointment
  include Enumerable

  attr_reader :department_id, :title_code, :step, :appointment_start_date, :appointment_end_date

  def initialize(department_id:, title_code:, step:, appointment_start_date:, appointment_end_date:)
    @department_id = department_id
    @title_code = title_code
    @step = step
    @appointment_start_date = appointment_start_date
    @appointment_end_date = appointment_end_date
  end

  def current?
    return false unless @appointment_end_date
    @appointment_end_date >= Date.today
  end

  def to_data_array
    [
      department_id, 
      title_code, 
      step, 
      appointment_start_date ? appointment_start_date.strftime('%m/%d/%Y') : '', 
      appointment_end_date ? appointment_end_date.strftime('%m/%d/%Y') : ''
    ]
  end

end
