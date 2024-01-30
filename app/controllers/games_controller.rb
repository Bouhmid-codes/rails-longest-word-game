require 'open-uri'

class GamesController < ApplicationController
  VOWELS = %w[A E I O U Y]

  def new
    @letters = Array.new(4) { VOWELS.sample }
    @letters += Array.new(6) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)
  end

  private

  def included?(word, letters)
    word.chars.all? do |letter|
      word.count(letter) <= letters.count(letter.upcase)
    end
  end

  def english_word?(word)
    json = JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{word}").read)
    json['found']
  end
end
