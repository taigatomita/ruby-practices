# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot

  def initialize(marks)
    @first_shot = Shot.new(marks[0])
    @second_shot = Shot.new(marks[1])
    @third_shot = Shot.new(marks[2])
  end

  def strike?
    first_shot.score == 10
  end

  def spare?
    !strike? && sum_first_two_scores == 10
  end

  def sum_scores
    [@first_shot, @second_shot, @third_shot].sum(&:score)
  end

  def sum_first_two_scores
    [@first_shot, @second_shot].sum(&:score)
  end
end
