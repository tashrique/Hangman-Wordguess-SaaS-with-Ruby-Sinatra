class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ""
    @wrong_guesses = ""
  end

  attr_accessor :word, :guesses, :wrong_guesses

  def guess(letter)
    
    # Check if guess is invalid
    if letter.nil? || letter.empty? || letter =~ /[^a-zA-Z]/
      raise ArgumentError, "Invalid Guess"
    end
    
    letter = letter.downcase
    # Check if guessed before
    if @guesses.include?(letter) || @wrong_guesses.include?(letter)
      return false
    end

    # Calculate guess
    if @word.include?(letter) && !@guesses.include?(letter)
      @guesses << letter
    elsif !@wrong_guesses.include?(letter)
      @wrong_guesses << letter
    end
  end

  def check_win_or_lose
    if @word == word_with_guesses
      :win
    elsif @wrong_guesses.length >= 7
      :lose
    else
      :play
    end
  end

  def word_with_guesses
    
    @word.chars.map do |char|
      @guesses.include?(char) ? char : "-"      
    end.join

  end



  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start do |http|
      return http.post(uri, "").body
    end
  end
end
