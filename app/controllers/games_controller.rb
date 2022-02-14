require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10)
  end

  def score
    letters = params[:letters].split("")
    answer = params[:answer]
    url = "https://wagon-dictionary.herokuapp.com/#{answer}"
    data_serialized = URI.open(url).read
    data = JSON.parse(data_serialized)

    @result =
      if answer.split("").all? { |char| letters.include?(char) } && data['found']
        "Congratulations! #{answer.upcase} is a valid English word!"
      elsif !data['found']
        "Sorry but #{answer.upcase} does not seem to be a valid English word..."
      else
        "Sorry but #{answer.upcase} can't be built out of #{letters}"
      end
  end
end
