class Congressman < ActiveRecord::Base
  include Services
  validates_presence_of :first_name, :last_name, :party, :state, :title

  # Return cached data or find it out.
  def information
    begin
      # TODO HIGH prateekm: Update this section
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

  def gather_committees_info
    begin
      Rails.logger.info "Fetching committees data for #{first_name} #{last_name}"
      committees_data = Sunlight.search_committees(bioguide_id)
      self.committees = committees_data.to_json
      save
    rescue Exception => e
      Rails.logger.info "Error getting committees data for: #{first_name} #{last_name}... #{e}"
    end
  end

  def gather_opencongress_info
    begin
      Rails.logger.info "Fetching opencongress data for #{first_name} #{last_name}"
      opencongress_data = OpenCongress.search_congressman(last_name, bioguide_id)
      unless opencongress_data.nil?
        save_opencongress_info(opencongress_data)
      end
      save
    rescue Exception => e
      Rails.logger.info "Error getting opencongress data for: #{first_name} #{last_name}... #{e}"
    end
  end

  def gather_capitolwords_info
    begin
      Rails.logger.info "Fetching capitolwords data for #{first_name} #{last_name}"
      capitolwords_data = CapitolWords.search(bioguide_id)
      self.capitolwords = capitolwords_data.to_json

      capitolwords_threads = [] #find information for all words in parallel
      capitolwords_data.map  do |word_data|
        WordInfo.find_or_create_by_word(word_data['ngram']) do |ngram|
          capitolwords_threads << Thread.new do
            word_result = ngram.add_information
          end
        end
      end

      capitolwords_threads.each {|t| t.join}
      save
    rescue Exception => e
      Rails.logger.info "Error getting capitolwords data for: #{first_name} #{last_name}... #{e}"
    end
  end


  def gather_opensecrets_info
    begin
      Rails.logger.info "Fetching opensecrets data for #{first_name} #{last_name}"
      contributor_data, industry_data =
          {}, {}

      contributor = Thread.new { contributor_data = OpenSecrets.search_contributors(crp_id) }
      industry = Thread.new { industry_data = OpenSecrets.search_industries(crp_id) }

      [contributor, industry].each { |t| t.join }

      self.opensecrets_contributors = contributor_data['opensecrets_contributors'].to_json
      self.opensecrets_industries = industry_data['opensecrets_industries'].to_json
      save
    rescue Exception => e
      Rails.logger.info "Error getting opensecrets data for: #{first_name} #{last_name}... #{e}"
    end
  end


  def save_opencongress_info(opencongress_data)
    begin
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
    rescue Exception => e
      Rails.logger.info "error for: #{first_name} #{last_name}... #{e}"
    end
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
