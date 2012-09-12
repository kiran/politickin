module Services

  module Sunlight
    extend Base

    URL = 'services.sunlightlabs.com/api/legislators.search.json'
    URL2= 'services.sunlightlabs.com/api/committees.allForLegislator'

    # Dig up dirt from Sunlight Labs...
    def self.search(name)
      safe_request('sunlight') do
        url = "#{URL}?apikey=#{ENV['SUNLIGHT']}&name=#{name}"
        # We need to perform a little weighting ourselves, because Sunlight labs
        # sometimes produces wonky results (try searching for "Bill Young")...
        candidates = get_json(url)['response']['results']
        return {} if candidates.empty?
        # candidates.each do |c|
        #   cand = c['result']
        #   cand['score'] += 0.3 if cand['legislator']['firstname'].match(/#{first_name}/i)
        #   cand['score'] += 0.3 if cand['legislator']['lastname'].match(/#{last_name}/i)
        # end
        winner = candidates.sort_by {|cand| cand['result']['score'] }.last
        score = winner['result']['score']
        raise Services::NotFoundException, "Can't find a legislator by that name..." unless score > 0.5
        winner['result']['legislator']['sunlight_score'] = score
        winner['result']['legislator']
      end
    end

    # Dig up dirt from Sunlight Labs...
    def self.search_committees(bioguide_id)
      safe_request('sunlight committees') do
        url = "#{URL2}?apikey=#{ENV['SUNLIGHT']}&bioguide_id=#{bioguide_id}"
        committees = get_json(url)['response']['committees']
        committees
      end
    end

  end

end