#!/usr/bin/env ruby

require_relative '../models/employee'
require_relative '../models/appointment'

class Processor
  include Enumerable

  MAX_APPOINTMENT = 5

  attr_reader :appointments, :employee

  def initialize(row)
    @row = row
  end

  def appointments

    MAX_APPOINTMENT.times.map do |i|
      appointment_start_date, appointment_end_date = appoitment_period(@row["appointment_period#{i + 1}"])

      Appointment.new(
        department_id: @row["department_id#{i + 1}"],
        title_code: @row["title_code#{i + 1}"],
        step: @row["step#{i + 1}"],
        appointment_start_date: (appointment_start_date ? Date.parse(appointment_start_date) : nil),
        appointment_end_date: (appointment_end_date ? Date.parse(appointment_end_date) : nil)
      )
    end
  end

  def employee
    @employee ||= Employee.new(employee_id: @row["employee_id"], name: @row["name"])
  end

  private

  def appoitment_period(period)
    period.to_s.split("|")
  end

end