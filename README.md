### Simple Blackjack game built with Ruby + Sinatra + MDL 

### DEMO

- DEMO LINK: https://mysterious-brook-75749.herokuapp.com

*Note: Demo does not work on Chrome browser*
- Issue Reference: http://stackoverflow.com/questions/33218375/sinatra-rack-session-lost-after-5-to-10-seconds

![Screenshot](/scr.png)


### How to start locally

```
git clone git@github.com:yhagio/simple_blackjack.git sb
cd sb
gem install sinatra
ruby app.rb
```

- [Install Ruby / Rails reference](http://railsapps.github.io/installrubyonrails-mac.html)
```
\curl -L https://get.rvm.io | bash -s stable
rvm install ruby-2.3.1
```

### Game Rule
Blackjack is a card game where you calculate the sum of the values of your cards and try to hit 21, aka "blackjack".

Both the player and dealer are dealt two cards to start the game.
All face cards are worth whatever numerical value they show.
Suit cards are worth 10. Aces can be worth either 11 or 1.
- Example: if you have a Jack and an Ace, then you have hit "blackjack", as it adds up to 21.

After being dealt the initial 2 cards, the player goes first and can choose to either "hit" or "stay". Hitting means deal another card. If the player's cards sum up to be greater than 21, the player has "busted" and lost. If the sum is 21, then the player wins. If the sum is less than 21, then the player can choose to "hit" or "stay" again. If the player "hits", then repeat above, but if the player stays, then the player's total value is saved, and the turn moves to the dealer.

By rule, the dealer must hit until she has at least 17. If the dealer busts, then the player wins. If the dealer, hits 21, then the dealer wins. If, however, the dealer stays, then we compare the sums of the two hands between the player and dealer; higher value wins.