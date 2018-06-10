# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

house_filename = File.join(Rails.root, 'data', 'houses.json')
JSON.parse(IO.read(house_filename)).each do |attrs|
  house = House.create(attrs)
  if house.invalid?
    puts "#{house.name}: #{house.errors.full_messages}"
  end
end
