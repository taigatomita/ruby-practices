require "date"
require "optparse"
opt = OptionParser.new
params = {}
opt.on("-y [VAL]"){|y| y}
opt.on("-m [VAL]"){|m| m}
opt.parse(ARGV, into: params)
if params[:y] == nil || params[:m] == nil
  calendar_date = Date.new(Date.today.year, Date.today.month)
else
  calendar_date = Date.new(params[:y].to_i, params[:m].to_i)
end
day_of_the_week = ["日", "月", "火", "水", "木", "金", "土"]
puts ("\s\s\s\s\s\s#{calendar_date.month}月 #{calendar_date.year}")
puts day_of_the_week.join(" ")
beginning_of_the_month = Date.new(calendar_date.year, calendar_date.month, 1)
end_of_the_month = Date.new(calendar_date.year, calendar_date.month, -1)
beginning_of_the_month.wday.times{print ("\s\s\s")}
(beginning_of_the_month..end_of_the_month).each do |x|
  print x.strftime("%e")
  if x.saturday?
    print "\n"
  else
    print "\s"
  end
end
print "\n
