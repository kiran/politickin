class Congressman < ActiveRecord::Base
  include Services
  validates_presence_of :first_name, :last_name, :party, :state, :title

  # Return cached data or find it out.
  def information
    begin
      gather_info if stale?
      self
    rescue Services::NotFoundException => e
      #self.destroy
      {'error' => e.message}.to_json
    end
  end
  
  def name
    [first_name, last_name].join(' ')
  end

  def party_name
    (party == 'R') ? 'Republican' : 'Democrat'
  end
  
  # Go out and re-spider this politician.
  def gather_info
    contributor_data, industry_data, capitolwords_data, committees_data, opencongress_data =
        {}, {}, {}, {}, {}

    contributor = Thread.new { contributor_data = OpenSecrets.search_contributors(crp_id) }
    industry = Thread.new { industry_data = OpenSecrets.search_industries(crp_id) }
    capitolwords = Thread.new { capitolwords_data = CapitolWords.search(bioguide_id) }
    committees = Thread.new { committees_data = Sunlight.search_committees(bioguide_id) }
    opencongress = Thread.new { opencongress_data = OpenCongress.search_congressman(last_name, bioguide_id) }

    [contributor, industry, committees, opencongress, capitolwords].each { |t| t.join }
    #a, b = Services.dig_up_dirt(first_name, last_name, crp_id, votesmart_id)
    self.opensecrets_contributors = contributor_data['opensecrets_contributors'].to_json
    self.opensecrets_industries = industry_data['opensecrets_industries'].to_json
    self.committees = committees_data
    self.capitolwords = capitolwords_data.to_json
    save_opencongress_data(opencongress_data)

    capitolwords_data.map {|blob|
      WordInfo.find_or_create_by_word(blob['ngram']) do |word|
        word.add_information
      end
    }
    save
  end


  def save_opencongress_data (opencongress_data)
    congressman = {}
    congressman['person_id'] = opencongress_data['person-stats']['person-id']

    congressman['abstains'] = opencongress_data['person-stats']['abstains']
    congressman['abstains_percentage'] = opencongress_data['person-stats']['abstains-percentage']
    congressman['abstains_percentage_rank'] = opencongress_data['person-stats']['abstains-percentage-rank']
    congressman['cosponsored_bills'] = opencongress_data['person-stats']['cosponsored-bills']
    congressman['cosponsored_bills_rank'] = opencongress_data['person-stats']['cosponsored-bills-rank']
    congressman['cosponsored_bills_passed'] = opencongress_data['person-stats']['cosponsored-bills-passed']
    congressman['cosponsored_bills_passed_rank'] = opencongress_data['person-stats']['cosponsored-bills-passed-rank']
    congressman['sponsored_bills'] = opencongress_data['person-stats']['sponsored-bills']
    congressman['sponsored_bills_rank'] = opencongress_data['person-stats']['sponsored-bills-rank']
    congressman['sponsored_bills_passed'] = opencongress_data['person-stats']['sponsored-bills-passed']
    congressman['sponsored_bills_passed_rank'] = opencongress_data['person-stats']['sponsored-bills-passed-rank']

    #add party loyalty stats
    congressman['with_party_percentage'] = opencongress_data['with-party-percentage']
    congressman['party_votes_percentage'] = opencongress_data['person-stats']['party-votes-percentage']
    congressman['party_votes_percentage_rank'] = opencongress_data['person-stats']['party-votes-percentage-rank']

    #add polarity stats
    congressman['total_session_votes'] = opencongress_data['total-session-votes']
    congressman['votes_democratic_position'] = opencongress_data['votes-democratic-position']
    congressman['votes_republican_position'] = opencongress_data['votes-republican-position']
    congressman['votes_least_often_with_id'] = opencongress_data['person-stats']['votes-least-often-with-id']
    congressman['votes_most_often_with_id'] = opencongress_data['person-stats']['votes-most-often-with-id']
    congressman['same_party_votes_least_often_with_id'] = opencongress_data['person-stats']['same-party-votes-least-often-with-id']
    congressman['opposing_party_votes_most_often_with_id'] = opencongress_data['person-stats']['opposing-party-votes-most-often-with-id']

    #add media data
    congressman['metavid_id'] = opencongress_data['metavid-id']
    congressman['recent_news'] = opencongress_data['recent-news']
    congressman['recent_blogs'] = opencongress_data['recent-blogs']

    update_attributes(congressman)
  end


  # Is our cache empty or past its expiration date?
  def stale?
    updated_at < 2.hours.ago
  end
  
  def self.search(search)
    if search
      where("((congressmen.first_name || ' ' || congressmen.last_name) ILIKE ?) OR (congressmen.first_name ILIKE ?) OR (congressmen.last_name ILIKE ?)", "%#{search}%", "%#{search}%", "%#{search}%")
    else
      find(:all)
    end
  end
end
