# Anywhere you need fake string data, use this method.
def fake_string
  words = []
  (rand(2)+2).times { words << DataFaker.hawaiian_word }
  words.join(' ')
end

# Don't use this method, use fake_string instead.
# Ok, you win, in the situation you described fake_word
# makes more sense.  Here you go, use it if you need to.
def fake_word
  DataFaker.hawaiian_word
end

# Basically, this is the faker gem + a shrink ray.
class DataFaker

  HAWAIIAN_VOWELS = %w( a e i o u )

  HAWAIIAN_CONSONANTS = %w( h k l m n p t w )

  def self.hawaiian_syllable
    s = ''
    if rand(100) < 90
      s << HAWAIIAN_CONSONANTS.sample
    end
    s << HAWAIIAN_VOWELS.sample
    s
  end

  def self.hawaiian_word
    word = ''
    (rand(3)+3).times { word << hawaiian_syllable }
    word
  end

end
