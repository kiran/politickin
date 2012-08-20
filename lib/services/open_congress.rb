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

        unless candidates_xml.nil?  # nil when timeouts or exceptions etc
          candidates_data = XmlSimple.xml_in(candidates_xml, 'ForceArray' => false, 'NoAttr' => true)
          # returns nil if person not found, else returns person's record
          if (candidates_data['people']['person'].size > 1) # if more than one person with same last name
            return candidates_data['people']['person'].select {|person| person['bioguide-id'] == bioguide_id}.first
          else
            return candidates_data['people']['person'].first
          end
        else
          return {}
        end
      end
    end
  end
end