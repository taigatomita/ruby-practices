# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(score_text)
    @score_text = score_text
  end

  def main
    scores = @score_text.split(',').flat_map { |s| s == 'X' ? [s, '0'] : s }
    divided_scores = scores.each_slice(2).to_a
    p divided_scores
    frames = adjust_final_frame(divided_scores).map { |scores| Frame.new(scores) }
    p divided_scores
    p calculate_score(frames)
  end

  private

  def adjust_final_frame(scores)
    last_shots = scores.slice(9..).flatten.reject { |s| s == '0' }
    scores << last_shots
    scores
  end

  def calculate_strike_score(frames, idx)
    point = frames[idx + 1].sum_first_two_scores
    point += frames[idx + 2].first_shot.score if frames[idx + 1].strike? && frames[idx + 2]
    point
  end

  def calculate_score(frames)
    point = 0
    frames.each_with_index do |frame, idx|
      point += frame.sum_scores
      break if idx == 9

      if frame.strike?
        point += calculate_strike_score(frames, idx)
      elsif frame.spare?
        point += frames[idx + 1].first_shot.score
      end
    end
    point
  end
end

game_score = Game.new(ARGV[0])
game_score.main
