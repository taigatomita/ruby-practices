# frozen_string_literal: true

require 'optparse'

@params = ARGV.getopts('l')
@total = Hash.new(0)

def main
  if ARGV.empty?
    word_count($stdin.read, 0) # ArgumentError,NoMethodErrorを避けるために第2引数を指定
  else
    ARGV.each_with_index do |name, i|
      file = File.open(name)
      word_count(file.read, i)
      file.close
    end
    show_total if ARGV.size >= 2
  end
end

def word_count(str, idx)
  state = {}
  state[:number_of_lines] = str.count("\n")
  state[:number_of_words] = str.split(/\s+/).size
  state[:number_of_bytes] = str.bytesize
  file_name = ARGV[idx]

  @total.merge!(state) { |_key, total_val, val| total_val + val }

  print "#{adjusting(state)} #{file_name}\n"
end

def show_total
  print "#{adjusting(@total)} total\n"
end

def adjusting(has)
  results = ''
  has.each_value do |val|
    results += " #{val.to_s.rjust(7)}"
    break if @params['l']
  end
  results
end

main
