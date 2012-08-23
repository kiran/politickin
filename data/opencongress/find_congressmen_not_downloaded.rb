#!/usr/bin/env ruby
require 'csv'

giant_hashmap = {}
File.open('opensort.tsv', 'r').each do |line|
  bioguide_id = line.split("\t")[2]
  giant_hashmap[bioguide_id] = "1"
end

file = File.open('remaining.csv', 'w')

csv_data = CSV.read 'sunlight_legislators_all.csv'
headers = csv_data.shift
file.puts headers.join(",")

string_data = csv_data.map { |row| row.map { |cell| cell.to_s } }
string_data.map do |row|
  bioguide_id = row[15]
  if giant_hashmap[bioguide_id].nil?
    file.puts row.join(",")
  end
end



# Write the results to a tsv file




