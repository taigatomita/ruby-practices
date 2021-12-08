# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(score_text)
    @score_text = score_text
  end

  def main
    shots = @score_text.split(',').map { |s| Shot.new(s) }
    scores = shots.flat_map { |s| s.strike? ? [s.score, 0] : s.score }
    divided_scores = scores.each_slice(2).to_a
    frames = adjust_last_frame(divided_scores).map { |scores| Frame.new(scores) }
    p calculate_score(frames)
  end

  private

  def adjust_last_frame(scores)
    new_scores = scores[0..8]
    last_score = scores[9..].flatten.reject(&:zero?)
    new_scores << last_score
    new_scores
  end

  def calculate_strike_score(frames, idx)
    point = frames[idx + 1].sum_first_two_scores
    point += frames[idx + 2].first_shot if frames[idx + 1].strike? && frames[idx + 2]
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
        point += frames[idx + 1].first_shot
      end
    end
    point
  end
end

game_score = Game.new(ARGV[0])
game_score.main
