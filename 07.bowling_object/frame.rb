# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot

  def initialize(marks)
    @first_shot = Shot.new(marks[0])
    @second_shot = Shot.new(marks[1]) || Shot.new(0)
    @third_mark = Shot.new(marks[2]) || Shot.new(0)
  end

  def strike?
    first_shot.score == 10
  end

  def spare?
    !strike? && total_of_2_throws == 10
  end

  def sum_scores
    [@first_shot.score, @second_shot.score, @third_mark.score].sum
  end

  def total_of_2_throws
    [@first_shot.score, @second_shot.score].sum
  end
end
