require_relative "parser"

module Charger
  class SummaryTable
    attr_reader :data
    attr_accessor :output

    def initialize data
      @data = data
      @output = ""
    end

    def self.draw data
      new(data).draw!
    end

    def draw!
      data.each_with_index do |row, index|
        render_row row, index
      end
      print output
      output
    end

    private

    def render_row row, r_index
      row.each_with_index do |cell, c_index|
        is_header = r_index == 0
        is_first = c_index == 0
        output << render_cell(cell, r_index, c_index)
        output << render_cell_separator(is_header, is_first)
      end
      output << "\n"
    end

    def render_cell cell, r_index, c_index
      cell.to_s.rjust(padding)
    end

    def render_cell_separator(is_header, is_first)
      if is_first && !is_header
        ": "
      else
        " "
      end
    end

    def padding
      @padding ||= (header.last).to_s.size
    end

    def header
      data.first
    end
  end
end
