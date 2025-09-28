class WordGuesserGame
  attr_accessor :word, :guesses, :wrong_guesses

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    raise ArgumentError if letter.nil? || letter.empty? || letter !~ /[A-Za-z]/
    letter = letter.downcase

    return false if @guesses.include?(letter) || @wrong_guesses.include?(letter)

    if @word.downcase.include?(letter)
      @guesses << letter
    else
      @wrong_guesses << letter
    end
    true
  end

  def word_with_guesses
    @word.chars.map { |ch|
      @guesses.include?(ch.downcase) ? ch : '-'
    }.join
  end

  def check_win_or_lose
    return :win  if word_with_guesses == @word
    return :lose if @wrong_guesses.length >= 7
    :play
  end

  def self.get_random_word
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.post_form(uri, {}).body
  end
end
