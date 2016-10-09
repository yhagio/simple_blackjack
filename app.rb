require 'rubygems'
require 'sinatra'
require 'pry'

set :sessions, true

# === Fix for Chrome:  Problems when POST requests are sent (Replace Line 5) ===
# use Rack::Session::Cookie, :key => 'rack.session',
#                            :path => '/',
#                            :secret => 'random_secret_string' 

# === Helper methods ===
helpers do
  def hi(name)
    "Hi, #{name}"
  end
end

# === Routes ===
get '/' do
  if session[:player_name]
    redirect '/game'
  else
    erb :set_name
  end
end

post '/set_name' do
  # binding.pry
  if params[:player_name].strip.size > 0
    session[:player_name] = params[:player_name]
    redirect '/game'
  else
    redirect '/'
  end
end

get '/game' do
  unless session[:player_name]
    redirect '/'
  end
  suits = ['H', 'D', 'S', 'C']
  card_values = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

  # session[:deck] = [];
  # ['H', 'D', 'S', 'C'].each do |suit|
  #   ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'].each do |face_value|
  #     session[:deck] << [suit, face_value]
  #   end
  # end
  session[:deck] = suits.product(card_values)
  session[:deck].shuffle!

  session[:player_cards] = []
  session[:dealer_cards] = []
  2.times do
    session[:dealer_cards] << session[:deck].pop
    session[:player_cards] << session[:deck].pop
  end
  
  erb :game
end