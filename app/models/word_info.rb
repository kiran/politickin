class WordInfo < ActiveRecord::Base
  include Services
  validates_presence_of :word

  def add_information
    phrase_info = CapitolWords.get_word_info(word)

    self.state = phrase_info['state'].to_json
    self.legislator = phrase_info['legislator'].to_json
    self.party = phrase_info['party'].to_json
    self.chamber = phrase_info['chamber'].to_json
    save
    #close db connections since this is called in multiple threads
    ActiveRecord::Base.connection.close
  end
end
