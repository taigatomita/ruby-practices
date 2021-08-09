# frozen_string_literal: true

score = ARGV[0] # スコアを受け取って配列へ
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = shots.each_slice(2).to_a # フレームごとに分割

last_shots = frames.slice!(9..).flatten.reject { |s| s.zero? } # 最終フレームの為の処理
frames << last_shots

point = 0
frames.each_with_index do |frame, idx| # スコアを加算していく
  point += frame.sum
  if frame[0] == 10 # ストライクの場合
    point = if frames[idx + 1]&.first.to_i == 10
              point + frames[idx + 1][0..1].sum.to_i + frames[idx + 2]&.first.to_i
            else
              frames[idx + 1] ? point + frames[idx + 1][0..1].sum : point
            end
  elsif frame.sum == 10 # スペアの場合
    point += frames[idx + 1]&.first.to_i
  end
end
p point
