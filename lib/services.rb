# Taken from jashkenas' wonderful Know Thy Congressman project.

# Services is like a sleuth that digs up the dirt on congressmen.
# Let's try to keep it all as stateless as possible, so that the threads don't
# step on each others toes.
module Services
  
  # If we can't find a resource for a particular congressman, then:
  class NotFoundException < RuntimeError; end
  
  # Dig up all the dirt available about a congressman...
  # Try to execute these calls as much in parallel as possible. However, some
  # requests must be made before others, so take care of that as well...
  # (eg. We need the name before looking up NYTimes tags, we need the tag before
  # looking for NYTimes articles).
  def self.dig_up_dirt(name)
    data = {'search_name' => name}
    sunlight_data, watchdog_data, flickr_data, contributor_data, industry_data, tags_data, articles_data, words_data =
      {}, {}, {}, {}, {}, {}, {}, {}

    sunlight = Thread.new { sunlight_data = Sunlight.search(name) }
    sunlight.join
    merge_data(data, sunlight_data)

    raise NotFoundException, "Can't find a legislator by that name..." if sunlight_data.empty?

    first_name, last_name = extract_name_from_congresspedia(data)
    bioguide_id, crp_id = data['bioguide_id'], data['crp_id']
    # watchdog = Thread.new { watchdog_data = Watchdog.search(bioguide_id) }
    # flickr = Thread.new { flickr_data = Flickr.search(first_name, last_name) }
    words = Thread.new { words_data = CapitolWords.search(bioguide_id) }
    contributor = Thread.new { contributor_data = OpenSecrets.search_contributors(crp_id) }
    industry = Thread.new { industry_data = OpenSecrets.search_industries(crp_id) }

    # tags = Thread.new { tags_data = NewYorkTimes.search_tags(data['search_first_name'], first_name, last_name) }
    # tags.join
    # merge_data(data, tags_data)
    
    # articles = Thread.new { articles_data = NewYorkTimes.search_articles(data['person_facet']) }
    
    #[watchdog, contributor, industry, articles, flickr, words].each { |t| t.join }
    #merge_data(data, watchdog_data, contributor_data, industry_data, articles_data, flickr_data, words_data)

    [watchdog, contributor, industry, words].each { |t| t.join }
    merge_data(data, watchdog_data, words_data, contributor_data, industry_data)
    data
  end
  
  private
  
  # Merge data from disparate APIs into a single body of (soon-to-be) JSON:
  def self.merge_data(data, *results)
    results.each {|result| data.merge!(result) }
  end
  
  # We really need to try to get a valid first name and last name. The sunlight
  # labs API takes care of searching for a congressperson, but sometimes returns
  # names with extra junk (like initials). Use the congresspedia url instead.
  def self.extract_name_from_congresspedia(data)
    url = data['congresspedia_url']
    unless url.blank?
      name = url.match(/\/wiki\/(.+)\Z/)[1].split('_')
      # Filter out mistaken middle names
      data['firstname'] = name[0].gsub(/\s\w+$/, '')
      data['lastname'] = name[-1]
    end
    return data['firstname'], data['lastname']
  end
  
end