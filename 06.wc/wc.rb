# frozen_string_literal: true

require 'optparse'

def main
  params = ARGV.getopts('l')
  total_stat = Hash.new(0)

  if ARGV.empty?
    stat = word_count($stdin.read)
    show(stat, '', params['l']) # ArgumentError,NoMethodErrorを避けるために空文字列を引数とする
  else
    ARGV.each do |name|
      file = File.open(name)
      stat = word_count(file.read)
      show(stat, name, params['l'])
      total_stat.merge!(stat) { |_key, total_val, val| total_val + val }
      file.close
    end
    show_total(total_stat, params['l']) if ARGV.size >= 2
  end
end

def word_count(str)
  {
    number_of_lines: str.count("\n"),
    number_of_words: str.split(/\s+/).size,
    number_of_bytes: str.bytesize
  }
end

def show(state, file_name, only_lines)
  puts " #{adjusting(state, only_lines)} #{file_name}"
end

def show_total(total_state, only_lines)
  puts " #{adjusting(total_state, only_lines)} total"
end

def adjusting(status, only_lines)
  return status.values.first.to_s.rjust(7) if only_lines

  status.values.map { |val| val.to_s.rjust(7) }.join(' ')
end

main
