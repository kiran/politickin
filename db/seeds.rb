# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Congressman.delete_all
# open("db/seeds/final_joined_tables.tsv") do |groups|
#     groups.read.each_line do |group|
#         next if group.empty?
#         name,party,title,constituency,json_stances = group.chomp.split("\t")
#         c = Congressman.create!(:name=>name, :party=>party, :title=>title, :constituency=>constituency, :json_stances=>json_stances)
#         c.gather_information
#     end
# end
require 'csv'

Congressman.delete_all
CSV.foreach("db/seeds/congressmen.csv") do |congressman|
  next if congressman.empty?
  c = Congressman.create!(:first_name=>congressman[0], :last_name=>congressman[1],
   :party=>congressman[2], :state=>congressman[3],
   :title=>"representative", :district =>congressman[4])
  # c.gather_information
end
CSV.foreach("db/seeds/senators.csv") do |congressman|
  next if congressman.empty?
  c = Congressman.create!(:first_name=>congressman[0], :last_name=>congressman[1],
   :party=>congressman[2], :state=>congressman[3],
   :title=>"senator", :district =>congressman[4])
  # c.gather_information
end