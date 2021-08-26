# frozen_string_literal: true

require 'optparse'

def main
  params = ARGV.getopts('l')
  total = Hash.new(0)

  if ARGV.empty?
    stat = word_count($stdin.read)
    show(stat, '', params['l']) # ArgumentError,NoMethodErrorを避けるために空文字列を引数とする
  else
    ARGV.each do |name|
      file = File.open(name)
      stat = word_count(file.read)
      show(stat, name, params['l'])
      total_count(total, stat)
      file.close
    end
    show_total(total, params['l']) if ARGV.size >= 2
  end
end

def word_count(str)
  state = {}
  state[:number_of_lines] = str.count("\n")
  state[:number_of_words] = str.split(/\s+/).size
  state[:number_of_bytes] = str.bytesize
  state
end

def show(state, file_name, params)
  print "#{adjusting(state, params)} #{file_name}\n"
end

def total_count(total, stat)
  total.merge!(stat) { |_key, total_val, val| total_val + val }
end

def show_total(total_result, params)
  print "#{adjusting(total_result, params)} total\n"
end

def adjusting(has, param)
  results = ''
  has.each_value do |val|
    results += " #{val.to_s.rjust(7)}"
    break if param
  end
  results
end

main
