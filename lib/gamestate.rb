############################################################################################################################
############################################################################################################################

# a gamestate is a unique snapshot of the game at a given point in time
# the ruleset is part of the simulation and is not represented here, although different rulesets allow for different player action possibilities
# a gamestate should be recorded each time the player executes an action except placing the initial bet which is automatic 
# (e.g. player dealt a two and a three and hits, player/dealer cards, current bet and player action are recorded, the action count is incremented)

############################################################################################################################
############################################################################################################################


class Gamestate

  def initialize
    @house_cards = []
    @player_cards = []
    @bet = 0
		@player_action = nil								# dealer action is according to a script -- we don't care about recording it because all dealer actions can be inferred from the ruleset
  end
  attr_accessor :house_cards, :player_cards, :bet, :player_action

############################################################################################################################
  
  def display_cards(house, player)
    # first display dealers hand on top, then player hand below
    # below hands (ascii layouts) display display rest of gamestate information
    # below display_gamestate we may want to display some summary statistics from the results class
    #todo: we want to print the layout of the cards side by side
    # use a 2d array where the card layouts are split by newline and are each stored as an array of lines in a larger, hand array
    # to display the first line of our hand then, we just print hand[0][0] through hand[n][0] with spacers in between, and then progress to the next row
    
    self.update_gamestate(house, player)
    
    puts colorize_green("Your Cards")+"                 "+colorize_green("Dealer Cards")    # 25 characters from start to d of dealer
    puts "----------                 ------------"
    card_array_lengths = []
    card_array_lengths << self.player_cards.length
    card_array_lengths << self.house_cards.length

    house_card_display_offset = 0
    if house.house_card_hidden == true
      house_card_display_offset = 1
    end
    
    card_index = 0
    until card_index > card_array_lengths.max
      player_card_string = String.new
      ten = false
      
      if card_index < self.player_cards.length
        player_card_string << self.player_cards[card_index].name + self.player_cards[card_index].symbol
        print colorize_blue(self.player_cards[card_index].name)
        
        # align suit symbols
        if self.player_cards[card_index].name =~ /10/
           print " "
           ten = true
        else
          print "  "
        end
        
        if self.player_cards[card_index].suit =~ /heart/i || self.player_cards[card_index].suit =~ /diamond/i
          print colorize_red(self.player_cards[card_index].symbol)
        else
          print colorize_white(self.player_cards[card_index].symbol)
        end
        
      else
        print "  "
      end
      
      (25 - player_card_string.length).times do
        print " "
      end
      
      if ten == true
        print " "
      end
            
      unless card_index > self.house_cards.length - 1 - house_card_display_offset # offset for zero index of array and possible offset for 1 hidden dealer card  
        
        # align suit symbols
        if self.house_cards[card_index].name =~ /10/
          print colorize_blue(self.house_cards[card_index].name) + " "
        else
          print colorize_blue(self.house_cards[card_index].name) + "  "
        end
        
        if self.house_cards[card_index].suit =~ /heart/i || self.house_cards[card_index].suit =~ /diamond/i 
          print colorize_red(self.house_cards[card_index].symbol)
        else
          print colorize_white(self.house_cards[card_index].symbol)
        end
        
      end
      
      if house.house_card_hidden == true && card_index == (self.house_cards.length - 1)
        print colorize_blue("-hidden card-")
      end
      
      puts
      card_index += 1
    end
    
    
  end

  
############################################################################################################################
  
  
  def display_current_bet_value()
    puts
    puts "         current bet = " + colorize_blue("$" + commatize(self.bet))
  end

  
############################################################################################################################
  
  
  def display_current_funds(house, player)
    puts
    puts "Your Funds:                Dealer Funds:"
    player_funds_string = String.new
    player_funds_string << "$" + commatize(player.funds.to_s)
    print colorize_blue("$"+commatize(player.funds.to_s))
    
    (27 - player_funds_string.length).times do
      print " "
    end
    
    print colorize_blue("$"+commatize(house.funds.to_s))
    
    puts
    puts colorize_white("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
  end


###################################################################################################################  
  
  
  def update_gamestate(house, player)
    self.house_cards = house.cards
    self.player_cards = player.cards
    self.bet = house.current_bet
  end
  
  
############################################################################################################################
############################################################################################################################
end