require 'date'
require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = 10.times.map { [*'A'..'Z'].sample }.sort.join('')
    @start_time = time_now
  end

  def score
    @time_diff = (time_now - params[:start_time].to_f).round(2)
    @word = params[:word]
    @letters = params[:letters]
    @let_array = @letters.split('')
    @msg = 'Good Work !'
    @result = 1

    @word.split('').each do |a|
      i = @let_array.index(a.upcase)
      if i.nil?
        @msg = "Unable to make '#{@word}'' out of the letters #{@letters.split("").join(', ')}"
        @result = 0
        break
      else
        @let_array.delete_at(i)
      end
    end

    unless @result.zero?
      url = "https://wagon-dictionary.herokuapp.com/#{@word}"
      @json = fetch(url)
      unless @json['found'] == true
        @result = 0
        @msg = "'#{@word}' is not a real word."
      end
    end
  end

  private

  def fetch(url)
    serialized = open(url).read
    JSON.parse(serialized)
  end

  def time_now
    Time.now.to_f
  end
end
