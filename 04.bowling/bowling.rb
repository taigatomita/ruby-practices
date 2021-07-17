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

frames = [] # フレームごとに分割
shots.each_slice(2) do |g|
  frames << g
end
if frames[11] # 10フレームに合わせる
  frames[9] += frames[10]
  frames.delete_at(10)
  frames[9] += frames[10]
  frames.delete_at(10)
elsif frames[10]
  frames[9] += frames[10]
  frames.delete_at(10)
else
  frames
end

frames.each do |frame| # ストライク後の0を消す
  frame.delete_at(1) if frame[0] == 10
end

point = 0
frames.each_with_index do |frame, idx| # スコアを加算していく
  if idx == 9
    point += frame.sum
  elsif idx == 8 && frame[0] == 10
    point += frame.sum + frames[9][0] + frames[9][1]
  elsif idx == 8 && frame.sum == 10
    point += frame.sum + frames[9][0]
  elsif frame[0] == 10 # ストライク
    point = if frames[idx + 1][0] == 10
              point + frame.sum + frames[idx + 1][0] + frames[idx + 2][0]
            else
              point + frame.sum + frames[idx + 1].sum
            end
  elsif frame.sum == 10
    point += frame.sum + frames[idx + 1][0]
  else
    point += frame.sum
  end
end
p point
