# frozen_string_literal: true

require 'optparse'
require_relative 'long_file_list'
require_relative 'display'

class Ls
  def initialize(options)
    @options = options
  end

  def output
    files = @options['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    files = files.reverse if @options['r']
    display = Display.new(files)
    @options['l'] ? display.display_option_l : display.column_display
  end
end

list_segments = Ls.new(ARGV.getopts('alr'))
list_segments.output
