require 'rubygems'
require 'sinatra'
# require 'pry'

# set :sessions, true

# === Fix for Chrome:  Problems when POST requests are sent (Replace Line 5) ===
use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => 'random_secret_string' 

# === Helper methods ===
helpers do
  def calculate_total(cards)
    values = cards.map{|card| card[1] }

    total = 0
    values.each do |val|
      if val == "ace"
        total += 11
      else
        total += (val.to_i == 0 ? 10 : val.to_i)
      end
    end

    #correct for Aces
    values.select{|val| val == "ace"}.count.times do
      break if total <= 21
      total -= 10
    end

    total
  end

  def display_card_image(card)
    "<img src='/images/cards/#{card[0]}_#{card[1]}.jpg' >"
  end

  def reset_game
    session[:deck] = nil
    session[:player_cards] = nil
    session[:dealer_cards] = nil
    redirect '/'
  end

  def quit_game
    session[:player_name] = nil
    session[:deck] = nil
    session[:player_cards] = nil
    session[:dealer_cards] = nil
    redirect '/'
  end

end

# === Before Filter ===
before do
  @show_hit_stay_buttons = true
  @dealer_hit_only = false
  @game_over = false
end

# === Routes ===
get '/' do
  if session[:player_name]
    redirect '/game'
  end
  erb :set_name
end

post '/set_name' do
  if params[:player_name].empty?
    @error = 'Name is required.'
    halt erb(:set_name)
  end
  session[:player_name] = params[:player_name]
  redirect '/game'
end

get '/game' do
  unless session[:player_name]
    redirect '/'
  end

  # Deck setup
  suits = ['hearts', 'diamonds', 'spades', 'clubs']
  card_values = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'jack', 'queen', 'king', 'ace']

  session[:deck] = suits.product(card_values)
  session[:deck].shuffle!

  session[:player_cards] = []
  session[:dealer_cards] = []
  2.times do
    session[:dealer_cards] << session[:deck].pop
    session[:player_cards] << session[:deck].pop
  end

  # Check if either get blackjack already
  if calculate_total(session[:player_cards]) == 21
    @won = 'You won! You hit Blackjack!'
    @show_hit_stay_buttons = false
    @game_over = true
  elsif calculate_total(session[:dealer_cards]) == 21
    @error = 'You lost! Dealer hit Blackjack!'
    @show_hit_stay_buttons = false
    @game_over = true
  end

  erb :game
end

post '/game/hit' do
  # Deal one card to player
  session[:player_cards] << session[:deck].pop

  # Check the total
  if calculate_total(session[:player_cards]) > 21
    @error = 'You lost! You busted!'
    @show_hit_stay_buttons = false
    @game_over = true
  elsif calculate_total(session[:player_cards]) == 21
    @won = 'You hit Blackjack!'
    @show_hit_stay_buttons = false
    @game_over = true
  end

  erb :game
end

post '/game/stay' do
  @show_hit_stay_buttons = false

  redirect '/game/dealer'
end

get '/game/dealer' do
  @show_hit_stay_buttons = false
  dealer_total = calculate_total(session[:dealer_cards])

  if dealer_total < 17
    @dealer_hit_only = true
  elsif dealer_total == 21
    @error = 'You lost! Dealer hit blackjack!'
    @show_hit_stay_buttons = false
    @game_over = true
  elsif dealer_total > 21
    @won = 'You won! Dealer busted!'
    @show_hit_stay_buttons = false
    @game_over = true
  else
    redirect '/game/compare'
  end

  erb :game
end

post '/game/dealer-hit' do
  session[:dealer_cards] << session[:deck].pop
  redirect '/game/dealer'
end

get '/game/compare' do
  dealer_total = calculate_total(session[:dealer_cards])
  player_total = calculate_total(session[:player_cards])

  if dealer_total > player_total
    @error = "You lost! Dealer got #{dealer_total}!"
    @show_hit_stay_buttons = false
    @game_over = true
  elsif player_total > dealer_total
    @won = "You won! Dealer got #{dealer_total}"
    @show_hit_stay_buttons = false
    @game_over = true
  else
    @won = "Tie game!"
    @show_hit_stay_buttons = false
    @game_over = true
  end

  erb :game
end

post '/reset-game' do
  reset_game()
end

post '/quit-game' do
  quit_game()
end

get '/about' do
  erb :about
end

get '/author' do
  erb :author
end

not_found do
  redirect '/'
end