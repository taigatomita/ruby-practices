# frozen_string_literal: true

class Frame
  def initialize(shots)
    @shots = shots
  end

  def first_shot
    @shots[0]
  end

  def strike?
    first_shot.strike?
  end

  def spare?
    !strike? && sum_first_two_scores == 10
  end

  def sum_scores
    @shots.compact.sum(&:score)
  end

  def sum_first_two_scores
    @shots[0..1].compact.sum(&:score)
  end
end
