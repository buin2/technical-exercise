#!/usr/bin/env ruby

# Write a program that reads data from a CSV file and produces an output CSV file.
# Usage: `ruby find_appointment.rb --file faculty_appointments.csv --title-code 1200`

require 'optparse'

require_relative 'lib/importer'
require_relative 'lib/processor'
require_relative 'lib/exporter'

class FacultyAppointment 
  attr_reader :file, :active_apt, :title_code

  def initialize(*args)
    parse_options(args)

    abort('No CSV file provided! Use --file to set it') unless file

    @active_apt ||= 1
  end

  def run
    puts "===== 1. Parsing CSV File #{file} " + (title_code ? " and filter appoitment by Title code #{title_code}" : '')
    imported_data = Importer.new(file)
    puts "===== 2. Processing data"
    parsed_data = process_data(imported_data)
    puts "===== 3. Exporting CSV"
    Exporter.new(parsed_data, filters).run
    puts "===== FINISH ====="
  end

  private

  def process_data(imported_data)
    imported_data.map do |data|
      Processor.new(data)
    end
  end

  def filters
    {
      active_apt: active_apt, 
      title_code: title_code,
    }
  end

  def parse_options(args)
    OptionParser.new do |opts|
      opts.banner = "Usage: #{$0} [options]"
      opts.separator ""
      opts.separator "Options:"

      opts.on("--file [filename]", "Name of the CSV file") {|v| @file = v }
      opts.on("--active-apt [Active Appt]", "Only return current/active appointment (0|1)") {|v| @active_apt = v.to_i }
      opts.on("--title-code [Title Code]", "Title code for filtering appointments") {|v| @title_code = v }
    end.parse! args
  end
end

FacultyAppointment.new(*ARGV).run() if $0 == __FILE__
