default_habits = ["風呂", "洗濯", "歯磨き"]

default_habits.each do |title|
  DefaultHabit.find_or_create_by!(title: title)
end

puts "✅ DefaultHabit seeds created: #{DefaultHabit.pluck(:title).join(', ')}"
