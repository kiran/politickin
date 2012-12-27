#!/usr/bin/env ruby
require 'rubygems'
require 'typhoeus'
require 'xmlsimple'
require 'json'
require 'csv'

URL = 'http://www.opensecrets.org/api/'

csv_data = CSV.read '../../db/seeds/sunlight_legislators_all.csv'
headers = csv_data.shift.map { |i| i.to_s }
string_data = csv_data.map { |row| row.map { |cell| cell.to_s } }
array_of_hashes = string_data.map { |row| Hash[*headers.zip(row).flatten] }

# Write the results to a tsv file
cont_file = File.open('opensecrets_contrib.tsv', 'a')
# Write the results to a tsv file
ind_file = File.open('opensecrets_industry.tsv', 'a')


array_of_hashes.each do |congressman|
  next if congressman.empty?
  name = congressman["first_name"] + " " + congressman["last_name"]
  contrib_url = "#{URL}?method=candContrib&output=json&cid=#{congressman['crp_id']}&apikey=38519242e33742c284478ce0982b7749"
  industry_url = "#{URL}?method=candIndustry&output=json&cid=#{congressman['crp_id']}&apikey=38519242e33742c284478ce0982b7749"
  begin
    begin
      contrib_response = Typhoeus::Request.get(contrib_url) #timeout = 1 min (in millisec)
      industry_response = Typhoeus::Request.get(industry_url) #timeout = 1 min (in millisec)
    rescue Exception => e
      puts "Server Error for for #{name}"
      next
    end

    contrib_body = contrib_response.body
    industry_body = industry_response.body

    rnf = 'Resource not found'
    if contrib_body.nil? || industry_body.nil? || contrib_body == rnf || industry_body == rnf
      puts "Resource not found for #{name}"
      next
    end

    puts "Got opensecrets data for #{name}"
    contrib_json = JSON.parse(contrib_response.body)
    industry_json = JSON.parse(industry_response.body)
    contrib_info = contrib_json['response']['contributors']['contributor']
    industry_info = industry_json['response']['industries']['industry']

    # need to replace => with : in response to be valid json
    contrib_data = [congressman['first_name'], congressman['last_name'],
        congressman['crp_id'], {'opensecrets_contributors' => contrib_info.map {|el| el['@attributes'] }.to_json}]
    industry_data = [congressman['first_name'], congressman['last_name'],
        congressman['crp_id'], {'opensecrets_industries' => industry_info.map {|el| el['@attributes'] }.to_json}]

    cont_file.puts contrib_data.join("\t")
    ind_file.puts industry_data.join("\t")

  rescue Exception => e
    puts "Error for #{name}:" + e.message
  end
end



