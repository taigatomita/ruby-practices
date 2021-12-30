# frozen_string_literal: true

class FileList
  SPECIFIED_NUMBER_OF_COLUMNS = 3

  def initialize(files)
    @files = files
  end

  def display
    file_column = transpose_matrix(@files)
    file_column.each do |file_name|
      result = file_name.compact.map { |string| string.ljust(max_number_of_chars(@files)) }.join('  ')
      puts result
    end
  end

  private

  def transpose_matrix(files)
    number_of_columns = (files.size.to_f / SPECIFIED_NUMBER_OF_COLUMNS).ceil
    divided_files = files.each_slice(number_of_columns).to_a
    divided_files.map { |file| file.values_at(0...number_of_columns) }.transpose
  end

  def max_number_of_chars(files)
    files.flatten.compact.max_by { |file_name| file_name.chars.size }.length
  end
end
