class WordInfo < ActiveRecord::Base
  include Services
  validates_presence_of :word

  # Go out and re-spider this politician.
  def add_information
    phrase_info = CapitolWords.get_word_info(word)

    self.state = phrase_info['state']
    self.legislator = phrase_info['legislator']
    self.party = phrase_info['party']
    self.chamber = phrase_info['chamber']
    save
  end
end
