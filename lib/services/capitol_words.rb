module Services

  module CapitolWords
    extend Base

    URL = 'http://capitolwords.org/api/phrases.json?entity_type=legislator'
    PhraseURL = 'http://capitolwords.org/api/phrases/'

    # Dig up the top 5 words in speeches by the politician over the course of the
    # last year.
    def self.search(bioguide_id)
      safe_request('capitol words') do
        url = "#{URL}&apikey=#{SECRETS['sunlight']}&entity_value=#{bioguide_id}&per_page=#{PARAMETERS['capitolwords_per_congressman']}"
        {'capitol_words' => get_json(url)}
      end
    end

    def self.get_word_info(phrase)
      safe_request('capitol words phrase info') do
        phrase_info = Hash.new

        legislator_url = "#{PhraseURL}legislator.json?phrase=free+market&sort=count&per_page=#{PARAMETERS['records_per_capitolword']}&apikey=#{SECRETS['sunlight']}"
        chamber_url = "#{PhraseURL}chamber.json?phrase=#{phrase}&apikey=#{SECRETS['sunlight']}"
        state_url = "#{PhraseURL}state.json?phrase=#{phrase}&per_page=#{PARAMETERS['records_per_capitolword']}&apikey=#{SECRETS['sunlight']}"
        party_url = "#{PhraseURL}party.json?phrase=#{phrase}&per_page=#{PARAMETERS['records_per_capitolword']}&apikey=#{SECRETS['sunlight']}"

        legislator = Thread.new {
          legislators_data = get_json(legislator_url)
          phrase_info['legislators'] = legislators_data['results']
        }
        chamber = Thread.new {
          chambers_data = get_json(chamber_url)
          phrase_info['chamber'] = chambers_data['results']
        }
        state = Thread.new {
          states_data = get_json(state_url)
          phrase_info['state'] = states_data['results']
        }
        party = Thread.new {
          parties_data = get_json(party_url)
          phrase_info['party'] = parties_data['results']
        }

        [legislator, chamber, state, party].each { |t| t.join }
        phrase_info
      end
    end

  end

end