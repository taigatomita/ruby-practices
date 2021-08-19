# frozen_string_literal: true

require 'etc'
require 'optparse'

def main
  params = ARGV.getopts('alr')
  @files = params['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : @files = Dir.glob('*') # ディレクトリ内のファイルを取得し配列として格納
  @files.reverse! if params['r']
  params['l'] ? long_listing_format : column_display
end

def show_permission_status(filemode)
  byte = [
    '---',
    '--x',
    '-w-',
    '-wx',
    'r--',
    'r-x',
    'rw-',
    'rwx'
  ]
  filemode.chars[-3..].map { |b| byte[b.to_i] }.join # パーミッション情報をアルファベットへ変換
end

def long_listing_format
  total_blocks = 0 # 総ブロック数を求める
  @files.each do |f|
    file = File::Stat.new(f)
    total_blocks += file.blocks
  end
  puts "total #{total_blocks}"

  @files.each do |f| # ファイルの状態を表示
    file_status = {}
    file = File::Stat.new(f)
    file_status[:file_name] = f
    file_status[:file_type] = file.ftype == 'file' ? '-' : file.ftype.slice(0)
    file_status[:file_mode] = show_permission_status(file.mode.to_s(8))
    file_status[:number_of_hard_links] = file.nlink
    file_status[:owner_name] = Etc.getpwuid(file.uid).name
    file_status[:group_name] = Etc.getgrgid(file.gid).name
    file_status[:byte_size] = file.size
    file_status[:changed_times] = file.ctime.strftime('%b %e %R')
    print("#{file_status[:file_type]}#{file_status[:file_mode]}  #{file_status[:number_of_hard_links]} ")
    print("#{file_status[:owner_name]}  #{file_status[:group_name]}  #{file_status[:byte_size]} #{file_status[:changed_times]} #{file_status[:file_name]}\n")
  end
end

def column_display
  specified_number_of_columns = 3
  number_of_columns = (@files.size.to_f / specified_number_of_columns).ceil
  array_of_split_files = @files.each_slice(number_of_columns).to_a # 配列を指定した列数に分割
  array_of_split_files.map! { |f| f.values_at(0...number_of_columns) } # 配列内の要素数が均等でない場合にnilを追加
  results = array_of_split_files.transpose # 行と列の反転

  length = results.flatten.compact.max_by { |name| name.chars.size }.size # 一番長い名前を持つファイルを見つけ出し、その文字数を横幅とする

  results.each do |str| # 揃えて表示
    str.map! do |file|
      file.to_s.ljust(length)
    end
    puts str.join('  ')
  end
end

main
