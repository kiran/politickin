module Services

  module CapitolWords
    extend Base

    URL = 'http://capitolwords.org/api/phrases.json?entity_type=legislator'

    # Dig up the top 5 words in speeches by the politician over the course of the
    # last year.
    def self.search(bioguide_id)
      safe_request('capitol words') do
        url = "#{URL}&apikey=#{SECRETS['sunlight']}&entity_value=#{bioguide_id}"
        {'capitol_words' => get_json(url)}
      end
    end

  end

end