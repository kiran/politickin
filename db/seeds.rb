# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'
Congressman.delete_all

# filename = db/seeds/...
# must have a header row, column names used as key in hash
def process_csv (filename, col_sep = ",")
  csv_data = CSV.read(filename, { :col_sep => col_sep })
  headers = csv_data.shift.map {|i| i.to_s }
  string_data = csv_data.map {|row| row.map {|cell| cell.to_s } }
  array_of_hashes = string_data.map {|row| Hash[*headers.zip(row).flatten] }
  array_of_hashes.each do |congressman|
    yield congressman
  end
end

# run through sunlight data
process_csv("db/seeds/sunlight_legislators_all.csv") do |congressman|
  next if congressman.empty?
  # don't remember why we need this restriction.
  # next if congressman['in_office'] == "0"
  c = Congressman.create!(congressman)
end

## run through watchdog data
#process_csv("db/seeds/watchdog_all.tsv", "\t") do |congressman|
#  next if congressman.empty?
#  c = Congressman.find_by_govtrack_id(congressman['govtrack_id'])
#  next if c.nil?
#  c.update_attributes(congressman)
#end

# run through opensecrets industry data
File.open('db/seeds/opensecrets_industry.tsv').each do |record|
  fname, fname2, crp_id, json_string = record.chomp.split("\t")

  #this is bad, shouldn't have saved opensecrets fields as a ruby hash.
  json = eval(json_string)['opensecrets_industries']
  next if json.empty?
  c = Congressman.find_by_crp_id(crp_id)
  next if c.nil?
  c.opensecrets_industries = json['opensecrets_industries'].to_json;
  c.save
end

# run through opensecrets contributor data
File.open('db/seeds/opensecrets_contrib.tsv').each do |record|
  fname, fname2, crp_id, json_string = record.chomp.split("\t")

  #this is bad, shouldn't have saved opensecrets fields as a ruby hash.
  json = eval(json_string)['opensecrets_contributors']
  next if json.empty?
  c = Congressman.find_by_crp_id(crp_id)
  next if c.nil?
  c.opensecrets_contributors = json['opensecrets_contributors'].to_json;
  c.save
end

def seed_opencongress_data (filename)
  File.open(filename).each do |record|
    fname, lname, bioguide_id, json_string = record.chomp.split("\t")
    json = JSON.parse(json_string)

    congressman = Hash.new
    congressman['person_id'] = json['person-stats']['person-id']

    congressman['abstains'] = json['person-stats']['abstains']
    congressman['abstains_percentage'] = json['person-stats']['abstains-percentage']
    congressman['abstains_percentage_rank'] = json['person-stats']['abstains-percentage-rank']
    congressman['cosponsored_bills'] = json['person-stats']['cosponsored-bills']
    congressman['cosponsored_bills_rank'] = json['person-stats']['cosponsored-bills-rank']
    congressman['cosponsored_bills_passed'] = json['person-stats']['cosponsored-bills-passed']
    congressman['cosponsored_bills_passed_rank'] = json['person-stats']['cosponsored-bills-passed-rank']
    congressman['sponsored_bills'] = json['person-stats']['sponsored-bills']
    congressman['sponsored_bills_rank'] = json['person-stats']['sponsored-bills-rank']
    congressman['sponsored_bills_passed'] = json['person-stats']['sponsored-bills-passed']
    congressman['sponsored_bills_passed_rank'] = json['person-stats']['sponsored-bills-passed-rank']

    #add party loyalty stats
    congressman['with_party_percentage'] = json['with-party-percentage']
    congressman['party_votes_percentage'] = json['person-stats']['party-votes-percentage']
    congressman['party_votes_percentage_rank'] = json['person-stats']['party-votes-percentage-rank']

    #add polarity stats
    congressman['total_session_votes'] = json['total-session-votes']
    congressman['votes_democratic_position'] = json['votes-democratic-position']
    congressman['votes_republican_position'] = json['votes-republican-position']
    congressman['votes_least_often_with_id'] = json['person-stats']['votes-least-often-with-id']
    congressman['votes_most_often_with_id'] = json['person-stats']['votes-most-often-with-id']
    congressman['same_party_votes_least_often_with_id'] = json['person-stats']['same-party-votes-least-often-with-id']
    congressman['opposing_party_votes_most_often_with_id'] = json['person-stats']['opposing-party-votes-most-often-with-id']

    #add media data
    congressman['metavid_id'] = json['metavid-id']
    congressman['recent_news'] = json['recent-news']
    congressman['recent_blogs'] = json['recent-blogs']

    next if congressman.empty? || congressman.nil? || congressman == {}
    c = Congressman.find_by_bioguide_id(json['bioguide-id'])
    if c.nil?
      puts "No congressman found for bioguide_id #{json['bioguide-id']}"
      next
    end
    c.update_attributes(congressman)
  end
end

# run through opencongress data
seed_opencongress_data("db/seeds/opencongress_all.tsv")
