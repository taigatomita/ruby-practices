# frozen_string_literal: true

require 'etc'

class LongFileList
  attr_reader :files

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

  def calculate_total_block
    @files.sum { |f| new_file_status(f).blocks }
  end

  def set_file_status_list
    @files.map do |file|
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

  private

  def new_file_status(file)
    File::Stat.new(file)
  end

  def convert_permission_status(filemode)
    filemode.chars[-3..].map { |b| PERMISSION_MARKS[b.to_i] }.join
  end
end
