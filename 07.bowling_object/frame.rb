# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot

  def initialize(shots)
    @first_shot = shots[0]
    @second_shot = shots[1] || 0
    @third_shot = shots[2] || 0
  end

  def strike?
    @first_shot == 10
  end

  def spare?
    !strike? && sum_first_two_scores == 10
  end

  def sum_scores
    [@first_shot, @second_shot, @third_shot].sum
  end

  def sum_first_two_scores
    [@first_shot, @second_shot].sum
  end
end
