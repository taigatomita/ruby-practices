# frozen_string_literal: true

class Shot
  def initialize(mark)
    @mark = mark
  end

  def score
    strike?(@mark) ? 10 : @mark.to_i
  end

  def strike?(mark)
    mark == 'X'
  end
end
