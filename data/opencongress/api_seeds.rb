#!/usr/bin/env ruby
require 'rubygems'
require 'typhoeus'
require 'xmlsimple'
require 'json'
require 'csv'

# Get information from opencongress by lastname and then filter by bioguide_id
def parse_opencongress_data(candidate_xml, bioguide_id)
  if candidate_xml.nil? # nil when timeouts or exceptions etc
    raise "Error getting opencongress data for #{bioguide_id}"
  else
    # ForceArray ['person'] forces the person field of xml to always be an array in the final result
    # even when there is only one person in results. Rest of the fields are not forced to be arrays.
    # NoAttr skips the attributes (the type attribute in opencongress xml) from the results
    candidates_data = XmlSimple.xml_in(candidate_xml, 'ForceArray' => ['person'], 'NoAttr' => true)

    # returns nil if person not found, else returns person's record
    # TODO MED prateekm: check what happens when 0 results, and if the condition can be skipped
    if candidates_data['people']['person'].size > 1 # if more than one person with same last name
      return candidates_data['people']['person'].select { |person| person['bioguide-id'] == bioguide_id }.first.to_json
    else
      return candidates_data['people']['person'].first.to_json
    end
  end
end

oc_url = 'http://api.opencongress.org/people?'
hydra = Typhoeus::Hydra.new(:max_concurrency => 1)
requests_array = []

csv_data = CSV.read 'sunlight_legislators_all.csv'
headers = csv_data.shift.map { |i| i.to_s }
string_data = csv_data.map { |row| row.map { |cell| cell.to_s } }
array_of_hashes = string_data.map { |row| Hash[*headers.zip(row).flatten] }

array_of_hashes.each do |congressman|
  next if congressman.empty?
  url = "#{oc_url}last_name=#{congressman['last_name']}"
  request = Typhoeus::Request.new(url, :timeout => 60000) #timeout = 1 min (in millisec)

  # Add current congressman to the request queue
  requests_array << request

  # This block is called when the request for current congressman is complete
  request.on_complete do |response|
    name = congressman['first_name'] + " " + congressman['last_name']
    sleep(1)
    begin
      if response.success?
        puts "Got opencongress data for #{name}"
        [congressman['first_name'], congressman['last_name'], congressman['bioguide_id'], parse_opencongress_data(response.body, congressman['bioguide_id'])]
      elsif response.timed_out?
        puts "Timeout for #{name}"
        return nil
      elsif response.code == 0
        # Could not get an http response, something's wrong.
        puts "Error for #{name}: #{response.curl_error_message}"
        return nil
      else
        # Received a non-successful http response.
        puts "Error for #{name}: HTTP request failed: " + response.code.to_s
        return nil
      end
    rescue Exception => e
      puts "Error for #{name}:" + e
    end
  end
end

requests_array.each { |request| hydra.queue request }

# Make the requests to the server
begin
  hydra.run
rescue Exception => e
  puts "Error making request to server."
end

# Write the results to a tsv file
file = File.open('ocd12.tsv', 'a')
requests_array.each do |request|
  begin
    response = request.handled_response
    unless response.nil?
      file.puts response.join("\t")
    end
  rescue Exception => e
    puts "Error writing data to file"
    next
  end
end
file.close


