# frozen_string_literal: true

class Display
  SPECIFIED_NUMBER_OF_COLUMNS = 3

  def initialize(files)
    @files = files
  end

  def column_display
    file_column = sort_by_columns(@files)
    max_num_of_chars = @files.flatten.compact.max_by { |name| name.chars.size }.length
    file_column.each do |file_name|
      result = file_name.map { |string| string.to_s.ljust(max_num_of_chars) } # nilを空文字へ変換するためにto_sを使用
      puts result.join('  ')
    end
  end

  def display_option_l
    long_file_list = LongFileList.new(@files)
    puts "total #{long_file_list.calculate_total_block}"
    print_file_status(long_file_list.set_file_status_list)
  end

  private

  def sort_by_columns(files)
    number_of_columns = (files.size.to_f / SPECIFIED_NUMBER_OF_COLUMNS).ceil
    divided_files = files.each_slice(number_of_columns).to_a
    divided_files.map { |f| f.values_at(0...number_of_columns) }.transpose
  end

  def print_file_status(file_status_list)
    file_status_list.each do |file_status|
      print("#{file_status[:file_type]}#{file_status[:file_mode]}  #{file_status[:number_of_hard_links]} ")
      print("#{file_status[:owner_name]}  #{file_status[:group_name]}  #{file_status[:byte_size]} #{file_status[:changed_times]} #{file_status[:file_name]}\n")
    end
  end
end
