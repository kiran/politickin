# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'
Congressman.delete_all

# run through sunlight database
csv_data = CSV.read 'db/seeds/sunlight_legislators_all.csv'
headers = csv_data.shift.map {|i| i.to_s }
string_data = csv_data.map {|row| row.map {|cell| cell.to_s } }
array_of_hashes = string_data.map {|row| Hash[*headers.zip(row).flatten] }
array_of_hashes.each do |congressman|
  next if congressman.empty?
  c = Congressman.create!(congressman)
end

# run through watchdog reps data
csv_data = CSV.read("db/seeds/watchdog_reps.tsv", { :col_sep => "\t" })
headers = csv_data.shift.map {|i| i.to_s }
string_data = csv_data.map {|row| row.map {|cell| cell.to_s } }
array_of_hashes = string_data.map {|row| Hash[*headers.zip(row).flatten] }
array_of_hashes.each do |congressman|
  next if congressman.empty?
  c = Congressman.find_by_govtrack_id(congressman['govtrack_id'])
  next if c.nil?
  c.update_attributes(congressman)
end

# run through watchdog senators data
csv_data = CSV.read("db/seeds/watchdog_senators.tsv", { :col_sep => "\t" })
headers = csv_data.shift.map {|i| i.to_s }
string_data = csv_data.map {|row| row.map {|cell| cell.to_s } }
array_of_hashes = string_data.map {|row| Hash[*headers.zip(row).flatten] }
array_of_hashes.each do |congressman|
  next if congressman.empty?
  c = Congressman.find_by_govtrack_id(congressman['govtrack_id'])
  next if c.nil?
  c.update_attributes(congressman)
end
