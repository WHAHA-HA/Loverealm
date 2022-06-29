class Word < ActiveRecord::Base
  paginates_per 50

  def self.create_form_list(list_of_words)
    list_of_words.split("\n").map do |word|
      word.strip!
      Word.find_or_create_by name: word
    end
  end
end
