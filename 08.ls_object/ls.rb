# frozen_string_literal: true

require 'optparse'
require_relative 'file_list'
require_relative 'long_file_list'

class Ls
  def initialize(options)
    @options = options
  end

  def output
    files = @options['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    files = files.reverse if @options['r']
    @options['l'] ? LongFileList.new(files).display : FileList.new(files).display
  end
end

list_segments = Ls.new(ARGV.getopts('alr'))
list_segments.output
