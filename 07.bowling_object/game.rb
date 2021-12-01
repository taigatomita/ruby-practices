# frozen_string_literal: true

require_relative 'frame'
require_relative 'shot'

class Game
  def initialize(argv)
    @scores = argv
  end

  def main
    array_of_scores = insert_0_after_x(@scores.split(','))
    devided_scores = slice_into_frames(array_of_scores)
    frames = adjusting_the_final_frame(devided_scores).map { |f| Frame.new(f) }
    p score_calculation(frames)
  end

  def insert_0_after_x(scores)
    shots = []
    scores.each { |s| s == 'X' ? shots.push(s, '0') : shots.push(s) }
    shots
  end

  def adjusting_the_final_frame(scores)
    last_shots = scores.slice!(9..).flatten.reject { |s| s == '0' }
    scores << last_shots
    scores
  end

  def slice_into_frames(array_of_socres)
    array_of_socres.each_slice(2).to_a
  end

  def strike_score_calculation(frames, idx)
    point = frames[idx + 1].total_of_2_throws
    point += frames[idx + 2].first_shot.score if frames[idx + 1].strike? && frames[idx + 2]
    point
  end

  def score_calculation(frames)
    point = 0
    frames.each_with_index do |frame, idx|
      point += frame.sum_scores
      next unless frames[idx + 1]

      if frame.strike?
        point += strike_score_calculation(frames, idx)
      elsif frame.spare?
        point += frames[idx + 1].first_shot.score
      end
    end
    point
  end
end

game_score = Game.new(ARGV[0])
game_score.main
