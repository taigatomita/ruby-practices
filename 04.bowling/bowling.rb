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

frames.each_with_index do |f, i| # 最終フレーム処理の準備
  next if i < 9

  f.delete(0)

  next unless i == 11

  frames[10] += f
end
frames.delete_if.with_index { |_frm, idx| idx > 10 }

point = 0
frames.each_with_index do |frame, idx| # スコアを加算していく
  next if idx == 10

  point += frame.sum
  if frame[0] == 10 # ストライクの場合
    point = if frames[idx + 1]&.first.to_i == 10
              point + frames[idx + 1]&.sum.to_i + frames[idx + 2]&.first.to_i
            else
              point + frames[idx + 1]&.sum.to_i
            end
  elsif frame.sum == 10 # スペアの場合
    point += frames[idx + 1]&.first.to_i
  end
end
p point
