#!/usr/bin/env ruby

require "csv"

class Importer
  include Enumerable

  def initialize(file)
    @file = file
  end

  def each(&block)
    CSV.foreach(file_path, headers: true) do |row|
      next if row.to_a.map(&:last).all?(&:nil?)

      yield row
    end
  end

  private

  def file_path
    "input/#{@file}"
  end

end