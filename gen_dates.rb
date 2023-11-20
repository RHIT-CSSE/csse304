require 'date'
require 'yaml'

start_date = Date.new(2023, 11, 27)
end_date = Date.new(2024, 02, 18)
vacation_start = Date.new(2023, 12, 23) #inclusive
vacation_end = Date.new(2024, 1, 7) # inclusive
allowed_days_of_week = [1,2,4,5] # monday is 1

generate_yaml = false #we either generate yaml or csv

day_list = []
current = start_date;
while(current <= end_date)
  if(current < vacation_start or current > vacation_end)
    day_list << current
  end
  current = current.next_day()
end
day_list =  day_list.keep_if { |d| allowed_days_of_week.include?(d.cwday()) }
class_index = 0;

if generate_yaml then
  string_list = day_list.map { |d|
    class_index = class_index + 1
    { "type" => "class_session",
      "class_num" => class_index,
      "date" => d.to_time().strftime("%Y-%m-%d 08:00") }
  }
  puts string_list.to_yaml
else
  day_list.each { |d|
    class_index = class_index + 1
    puts " Day #{class_index} , #{d.to_time().strftime("%Y-%m-%d 23:59")}"
  }
end
$stderr.puts "#{day_list.length} days output as #{ generate_yaml ? 'YAML (not csv)' : 'CSV (not YAML)' } "
