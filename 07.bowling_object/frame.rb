# frozen_string_literal: true

class Frame
  def initialize(shots)
    @shots = shots
  end

  def first_shot
    @shots.first
  end

  def strike?
    first_shot.strike?
  end

  def spare?
    !strike? && sum_first_two_shots == 10
  end

  def sum_shots
    @shots.compact.sum(&:score)
  end

  def sum_first_two_shots
    @shots.first(2).compact.sum(&:score)
  end
end
