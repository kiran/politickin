module Services

  module OpenCongress
    extend Base
    require 'xmlsimple'

    URL = 'http://api.opencongress.org/people?'

    # Get information from opencongress by lastname and then filter by bioguide_id
    def self.search_congressman(last_name, bioguide_id)
      safe_request('opencongress') do
        url = "#{URL}last_name=#{last_name}"
        candidates_xml = get_xml(url)
        candidates_data = XmlSimple.xml_in(candidates_xml, 'ForceArray' => false, 'NoAttr' => true)
        # returns nil if person not found, else returns person's record
        # trivia: most common last name = Davis (8 occurrences)
        # if more than one person with same last name
        if (candidates_data['people']['person'].size > 1)
          return candidates_data['people']['person'].select {|person| person['bioguide-id'] == bioguide_id}.first
        else
          return candidates_data['people']['person'].first
        end
      end
    end
  end
end