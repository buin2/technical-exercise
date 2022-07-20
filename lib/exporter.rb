#!/usr/bin/env ruby

require "csv"

class Exporter

  def initialize(output_data, filters={})
    @output_data = output_data
    @filters = filters
  end
    
  def run
    output_csv(run_filter)
  end

  private

  def csv_header
    ["employee_id", "name", "department_id", "title_code", "step", "appt_begin_date", "appt_end_date"]
  end

  def only_active_apt?
    @filters[:active_apt].to_i == 1
  end

  def only_title_code?
    @filters[:title_code].to_i > 0
  end

  def run_filter
    appointments = [csv_header]

    @output_data.each do |record|
      record.appointments.each do |apt|
        next unless apt.current? if only_active_apt?
        next unless (apt.title_code.to_i == @filters[:title_code].to_i) if only_title_code?
        
        appointments << record.employee.to_data_array + apt.to_data_array
      end
    end

    appointments
  end

  def output_csv(appointments)
    CSV.open(output_path, 'w') do |csv|
      appointments.each { |row| csv << row }
    end
  end

  private

  def output_path
    "output/output" + (@filters[:title_code] ? "-" + @filters[:title_code].to_s : "") + ".csv"
  end

end