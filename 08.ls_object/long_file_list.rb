# frozen_string_literal: true

require 'etc'

class LongFileList
  PERMISSION_MARKS = [
    '---',
    '--x',
    '-w-',
    '-wx',
    'r--',
    'r-x',
    'rw-',
    'rwx'
  ]

  def initialize(files)
    @files = files
  end

  def display
    puts "total #{calculate_total_block(@files)}"
    print_file_status(file_status_list(@files))
  end

  private

  def file_status_list(files)
    files.map do |file|
      file_stat = new_file_status(file)
      {
        file_name: file,
        file_type: file_stat.ftype == 'file' ? '-' : file_stat.ftype.slice(0),
        file_mode: convert_permission_status(file_stat.mode.to_s(8)),
        number_of_hard_links: file_stat.nlink,
        owner_name: Etc.getpwuid(file_stat.uid).name,
        group_name: Etc.getgrgid(file_stat.gid).name,
        byte_size: file_stat.size,
        changed_times: file_stat.ctime.strftime('%b %e %R')
      }
    end
  end

  def print_file_status(file_status_list)
    file_status_list.each do |file_status|
      print("#{file_status[:file_type]}#{file_status[:file_mode]}  #{file_status[:number_of_hard_links]} ")
      print("#{file_status[:owner_name]}  #{file_status[:group_name]}  #{file_status[:byte_size]} #{file_status[:changed_times]} #{file_status[:file_name]}\n")
    end
  end

  def new_file_status(file)
    File::Stat.new(file)
  end

  def convert_permission_status(filemode)
    filemode.chars[-3..].map { |octal| PERMISSION_MARKS[octal.to_i] }.join
  end

  def calculate_total_block(files)
    files.sum { |file| new_file_status(file).blocks }
  end
end