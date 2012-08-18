class Congressman < ActiveRecord::Base
  include Services
  validates_presence_of :first_name, :last_name, :party, :state, :title

  # Return cached data or find it out.
  def information
    begin
      gather_information if stale?
      self.json
    rescue Services::NotFoundException => e
      self.destroy
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
    contributor_data, industry_data, capitolwords_data = {}, {}, {}

    contributor = Thread.new { contributor_data = OpenSecrets.search_contributors(crp_id) }
    industry = Thread.new { industry_data = OpenSecrets.search_industries(crp_id) }
    capitolwords = Thread.new { capitolwords_data = CapitolWords.search(bioguide_id) }

    [contributor, industry].each { |t| t.join }
    #a, b = Services.dig_up_dirt(first_name, last_name, crp_id, votesmart_id)
    self.opensecrets_contributors = contributor_data['opensecrets_contributors'].to_json
    self.opensecrets_industries = industry_data['opensecrets_industries'].to_json

    capitolwords.join
    capitolwords_data['capitol_words'].map {|blob|
      WordInfo.find_or_create_by_word(blob['ngram']) do |word|
        word.add_information
      end
    }
    save
  end
  
  
  # Is our cache empty or past its expiration date?
  def stale?
    updated_at < 2.hours.ago
    # rue
  end
  
  def self.search(search)
    if search
      where("((congressmen.first_name || ' ' || congressmen.last_name) ILIKE ?) OR (congressmen.first_name ILIKE ?) OR (congressmen.last_name ILIKE ?)", "%#{search}%", "%#{search}%", "%#{search}%")
    else
      find(:all)
    end
  end
end
