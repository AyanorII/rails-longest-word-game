require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10)
    @start_time = Time.now.xmlschema
  end

  def score
    letters = params[:letters].split('')
    answer = params[:answer]
    start_time = params[:start_time].to_datetime
    data = fetch_data(answer)
    end_time = Time.now
    time_diff = (end_time - start_time).round(2)
    score = (data['length'] * (30 - time_diff)).round(2)

    @result =
      if answer.split('').all? { |char| letters.include?(char) } && data['found']
        "Congratulations! #{answer.upcase} is a valid English word!\n
        Word length: #{data['length']} - Time: #{time_diff}s - Score: #{score}"
      elsif !data['found']
        "Sorry but #{answer.upcase} does not seem to be a valid English word..."
      else
        "Sorry but #{answer.upcase} can't be built out of #{letters}"
      end
  end

  private

  def fetch_data(keyword)
    url = "https://wagon-dictionary.herokuapp.com/#{keyword}"
    data_serialized = URI.open(url).read
    JSON.parse(data_serialized)
  end
end
