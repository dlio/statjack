###################################################################################################################
###################################################################################################################

# the game class will contain information only about the current game actively being played
# the array of gamestates will contain a set of snapshots of the game status at each point in time
# at the end of a game, it is to be processed by simulation.results, where summary statistics will be kept

###################################################################################################################
###################################################################################################################


class Game

  def initialize
    @gamestates = []
    @outcome = nil
    @final_bet_value = nil
	end
	attr_accessor :gamestates, :outcome, :final_bet_value

###################################################################################################################   

  def display_current_gamestate(house, player)
    # here we want to be able to present a consistent interface that shows house/player hands & funds, bet value, hands played, other stats, etc.
    # beneath this game status we can print menus to allow interaction at various stages throughout the game
    self.gamestates.last.display_cards(house, player)
    
    # display current hand values for house and player
    puts
    puts "You Have:                  Dealer Has:"
    
    player_hand_values_string = String.new
    player.current_hand_values.each do |chv|
      player_hand_values_string << chv.to_s + ", "
    end    
    player_hand_values_string.gsub!(/,\s$/,'')
		
    print colorize_white(player_hand_values_string)
    
    (27 - player_hand_values_string.length).times do
        print " "
      end
    
    house_hand_values_string = String.new
    house.current_hand_values.each do |chv|
        house_hand_values_string << chv.to_s + ", "
    end
    house_hand_values_string.gsub!(/,\s$/,'')
    
    print colorize_white(house_hand_values_string)
    
    puts
    
    self.gamestates.last.display_current_bet_value()
    self.gamestates.last.display_current_funds(house, player)
  end

  
###################################################################################################################
###################################################################################################################


  def play(house, player, ruleset, shoe)  
    
    # place initial bet
    player.place_bet(ruleset.minimum_bet, house)
    
    if Menu.display_prompt_for_initial_bet_increase() == true
      puts colorize_white("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
      puts "Initial Bet (minimum): " + colorize_blue("$" + commatize(house.current_bet)) + "\n\n" 
      puts colorize_white("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
      
      Menu.display_initial_bet_menu()
      selection = Menu.get_initial_bet_menu_selection()
      
      case selection
        when /yes|y/, 1
          # allow increase by increments of ruleset.bet_denomination
          Menu.display_increase_initial_bet_submenu()
          selection = Menu.get_increase_initial_bet_value()

          player.place_bet(selection.to_i, house)
        
        when /no/, 2
          # do nothing
        
        when /stop|s|stop\sasking\sme\sthis|stop_asking_me_this/, 3
          Menu.set_display_prompt_for_initial_bet_increase(false)
          
        when /exit|quit/   # should be options to 1. exit program 2. return to main menu 3. cancel
          Menu.display_exit_menu()
          selection = Menu.get_exit_menu_selection()

          Menu.clear_screen()
          
          # respond to user selection
          case selection
            when /^exit$|^quit$|^exit\sprogram$|^quit\sprogram$/, 1
              puts colorize_blue("Goodbye!")
              Process.exit
              
            when /^return$|^return\sto\smain\smenu$|^main\smenu$/, 2
              self.outcome = :aborted
              return
            
            when /^cancel$/, 3
              # do nothing
        
          end
      
        end
      
    end     
    # intial bet has now been placed
    
    #______________________________________________________________________________________________#
    
    # deal cards
    2.times do
      player.cards << shoe.deal_card()
      house.cards << shoe.deal_card()
    end
    
    shoe.total_hands_dealt += 1
    shoe.hands_since_shuffle += 1
    
    # only 1 dealer card is visible
    house.house_card_hidden = true
    
    # calculate possible hand values
    player.calculate_current_hand_values()
    house.calculate_current_hand_values()
    
    unless player.possible_actions.include?("double_down")
      player.possible_actions << "double_down"
    end
    
    # after cards have been dealt, if they are a pair, add split to player's possible actions
    if player.cards[0].value == player.cards[1].value
      player.possible_actions << "split"
    end
    
    # if the surrender rule is enabled, add surrender to player's possible actions
    if ruleset.surrender == true
      player.possible_actions << "surrender"
    end
    
    # if the insurance rule is enabled and the dealer is showing an ace, add insurance to possible actions
    if ruleset.insurance == true && house.cards[0].name =~ /a/i
      player.possible_actions << "insurance"
    end

    # initialze gamestate, append it to gamestates array and set current gamestate values
    gamestate = Gamestate.new
    self.gamestates << gamestate
    self.gamestates.last.update_gamestate(house, player)
    
    
    #______________________________________________________________________________________________#

    # player to act until blackjack, stand, bust, or surrender
    player_done_acting = false
    isurance_purchased = false
    
    # check for blackjack (initial 21 with only 2 cards)  if we find a blackjack, we can skip player actions
    player.current_hand_values.each do |chv|
      if chv == 21
        player_done_acting = true
        self.outcome = :blackjack
        display_current_gamestate(house, player)
      end
    end
    
    until player_done_acting == true
        
      Menu.clear_screen()
      display_current_gamestate(house, player)
      Menu.display_possible_actions_menu(player)
      selection = Menu.get_possible_actions_menu_selection(house, player, self.gamestates.last)
      
      # player selection has been made and validated
      
      # record action
      self.gamestates.last.player_action = selection
      
      case selection
        
        when /stand/, 1
          player_done_acting = true
        
        when /hit/, 2
          player.cards << shoe.deal_card()
          
        when /double/, 3
          player.place_bet(house.current_bet, house)
          player.cards << shoe.deal_card()
          player_done_acting = true
        
        when /insurance/, 4
          # place insurance side-bet.  only possible if dealer is showing an ace and only if available via the ruleset
          player.funds -= ruleset.minimum_bet
          insurance_purchased = true
          # only possible once per hand
          player.possible_actions.delete_if {|action| action =~ /insurance/}
          puts "\nInsurance purchased for "+colorize_blue("$"+commatize("#{ruleset.minimum_bet}"))+".  (pays 2:1)\n"
          puts "Press enter to continue: "
          gets
          
        when /surrender/, 5
          player_done_acting = true
          self.outcome = :surrender
      
        when /split/, 6
          # todo
        
        when /exit|quit/
          Menu.display_exit_menu()
          selection = Menu.get_exit_menu_selection()

          Menu.clear_screen()
          
          # respond to user selection
          case selection
            when /^exit$|^quit$|^exit\sprogram$|^quit\sprogram$/, 1
              puts colorize_blue("Goodbye!")
              Process.exit
              
            when /^return$|^return\sto\smain\smenu$|^main\smenu$/, 2
              self.outcome = :aborted
              return
            
            when /^cancel$/, 3
              # do nothing
        
          end
          
      end
      # current player action completed

      # after player action has been selected, recorded, and conducted, append a new gamestate & update it
      gamestate = Gamestate.new
      self.gamestates << gamestate
      self.gamestates.last.update_gamestate(house, player)
      
      # calculate possible hand values
      player.calculate_current_hand_values()
      house.calculate_current_hand_values() 
      
      # check game conditions and set player_done_acting = true if player bust or if player has 21
      if player.current_hand_values.min > 21
        player_done_acting = true
        self.outcome = :player_loss      
      else 
        player.current_hand_values.each do |chv|
          if chv == 21
            player_done_acting = true
          end
        end
      end
    
      # after the first move, the only available actions are hit and stand or insurance if available
      player.possible_actions.delete_if {|action| action !~ /hit|stand|insurance/}  
    end  
    # player is now done acting
    
    #______________________________________________________________________________________________#
   
    # once player is done acting, set house_card_hidden to false (i.e. house flips over card)
    house.house_card_hidden = false
    house.calculate_current_hand_values() 
    
    # house to act: (dealer script)

      # check for soft 17
      soft_17 = false
      
      if ruleset.house_hits_soft_17 == true && house.current_hand_values.max == 17
        house.cards.each do |card|
          if card.name =~ /a/i
            soft_17 = true
          end
        end     
      end

      
      # dealer takes cards until dealer script conditions are met 
      until ( house.current_hand_values.max >= 17 || self.outcome != nil ) && soft_17 == false
        sleep(1)
        house.cards << shoe.deal_card()
        self.gamestates.last.update_gamestate(house, player)
        house.calculate_current_hand_values()
        
        
        Menu.clear_screen()
        display_current_gamestate(house, player)
           
        # check for soft 17
        if ruleset.house_hits_soft_17 == true
          soft_17 = false
          if house.current_hand_values.max == 17
            house.cards.each do |card|
              if card.name =~ /a/i
                soft_17 = true
              end
            end
          end         
        end
       
        # before testing house current hand values, remove values that would cause bust if there is at least one value under 21
        if house.current_hand_values.length > 1 && house.current_hand_values.min < 21
          house.current_hand_values.delete_if {|current_hand_value| current_hand_value > 21}
        end
        sleep(1)
      end
    
    # calculate final hand values 
    player.calculate_current_hand_values()
    house.calculate_current_hand_values()
    
    Menu.clear_screen()
    display_current_gamestate(house, player)
    
      
    # if the lowest possible value of the player's hand is > 21, the player busts
    if player.current_hand_values.min > 21
      self.outcome = :player_loss
      
    # else if the house is bust, the player wins
    elsif house.current_hand_values.min > 21
      self.outcome = :player_win
    
    # otherwise, handle push, player non-blackjack win and player non-bust loss, unless player has already surrendered
    elsif self.outcome !~ /surrender/ 
      # since we have come this far and already checked for blackjack and player/house busts we can remove possible hand values above 21 from consideration
      player.current_hand_values.delete_if {|chv| chv > 21}
      house.current_hand_values.delete_if {|chv| chv > 21}
      
      # handle push
      if player.current_hand_values.max == house.current_hand_values.max
        self.outcome = :push
      
      # handle win
      elsif player.current_hand_values.max > house.current_hand_values.max && self.outcome !~ /blackjack/
        self.outcome = :player_win
      
      # handle loss
      elsif house.current_hand_values.max > player.current_hand_values.max
        self.outcome = :player_loss
      
      end
        
    end
      
    # set final bet value
    self.final_bet_value = self.gamestates.last.bet
    
    # handle game outcome (i.e.  payout/bet/funds for house and player)
    puts
    case self.outcome
      
      when /blackjack/
        # increase current bet in anticipation of payout
        house.current_bet +=  house.current_bet + (house.current_bet * ruleset.payout_ratio).to_i
        # subtract current bet from house funds
        house.funds -=  house.current_bet
        # add current bet to player funds
        
        player.funds += house.current_bet
        print "     "
        puts "You " + colorize_green("won!")
        print "     "
        puts "Congratulations, you got " + colorize_blue("blackjack") +"."
        print "     "
        puts "You have won " + colorize_green("$"+commatize(house.current_bet)) + "\n\n"
        
      when /player_win/
        print "     "
        puts "You " + colorize_green("won!")
        print "     "
        puts "Congratulations."
        print "     "
        puts "You have won " + colorize_green("$"+commatize(house.current_bet)) + "\n"
        # double current bet in anticipation of payout
        house.current_bet += house.current_bet
        # subtract current bet from house funds
        house.funds -= house.current_bet
        # add current bet to player funds
        player.funds += house.current_bet
        
      when /player_loss/
        print "     "
        puts "You " + colorize_red("lost") + "."
        print "     "
        puts "You have lost " + colorize_red("$"+commatize(house.current_bet))
        print "     "
        puts "Deal with it.\n"
        house.funds += house.current_bet
        
      when /push/
        print "     "
        puts "You tied with the Dealer."
        print "     "
        puts "Your bet of " + colorize_blue("$"+commatize(house.current_bet)) + " has been refunded.\n"
        player.funds += house.current_bet
      
      when /surrender/
        print "     "
        puts "You got scared and surrendered."
        print "     "
        puts "Half of your bet has been refunded."
        print "     "
        puts "(" + colorize_blue("$"+commatize(house.current_bet / 2)) + ") of " + colorize_blue("$"+commatize(house.current_bet)) + ").\n"
        player.funds += house.current_bet / 2
        house.funds += house.current_bet / 2
        
    end
    
    # zero current bet
    house.current_bet = 0
    
    if insurance_purchased == true
      if house.cards.length == 2 && house.current_hand_values.max == 21   # if dealer got blackjack
        player.funds += ruleset.minimum_bet * 2
        house.funds -= ruleset.minimum_bet * 2  
        print "     "
        puts "Insurance bet "+colorize_green("won!")
        print "     "
        puts "You have won " + colorize_green("$"+commatize(ruleset.minimum_bet * 2)) + "\n"
        
      else
        # remember, insurance already purchased above by player
        house.funds += ruleset.minimum_bet
        print "     "
        puts "Insurance bet "+colorize_red("lost.")
        print "     "
        puts "You have lost " + colorize_red("$"+commatize(ruleset.minimum_bet)) + "\n"
      end
    end
    
    # handle shoe cleanup 
    shoe.total_hands_dealt += 1
    
    # discard cards
    player.cards = []
    player.current_hand_values = []
    house.cards = []
    house.current_hand_values = []
    
    # shuffle if necessary
    shoe.hands_since_shuffle += 1
    if shoe.hands_since_shuffle >= ruleset.hands_between_shuffles || shoe.unplayed_cards.length < 25
      shoe.shuffle()
      shoe.hands_since_shuffle = 0
      shoe.total_shuffles += 1
    end
    
    return self
  end

###################################################################################################################   
###################################################################################################################   


  def simulate(house, player, ruleset, shoe, obj_rb)  
    
		Kernel::srand obj_rb
		
    # place initial bet
    player.place_bet(ruleset.minimum_bet, house)
    
    # intial bet has now been placed
    
    #______________________________________________________________________________________________#
    
    # deal cards
    2.times do
      player.cards << shoe.deal_card()
      house.cards << shoe.deal_card()
    end
    
    shoe.total_hands_dealt += 1
    shoe.hands_since_shuffle += 1
    
    # only 1 dealer card is visible
    house.house_card_hidden = true
    
    # calculate possible hand values
    player.calculate_current_hand_values()
    house.calculate_current_hand_values()
    
    unless player.possible_actions.include?("double_down")
      player.possible_actions << "double_down"
    end
    
    # after cards have been dealt, if they are a pair, add split to player's possible actions
    if player.cards[0].value == player.cards[1].value
      player.possible_actions << "split"
    end
    
    # if the surrender rule is enabled, add surrender to player's possible actions
    if ruleset.surrender == true
      player.possible_actions << "surrender"
    end
    
    # if the insurance rule is enabled and the dealer is showing an ace, add insurance to possible actions
    if ruleset.insurance == true && house.cards[0].name =~ /a/i
      player.possible_actions << "insurance"
    end

    # initialze gamestate, append it to gamestates array and set current gamestate values
    gamestate = Gamestate.new
    self.gamestates << gamestate
    self.gamestates.last.update_gamestate(house, player)
    
    
    #______________________________________________________________________________________________#

    # player to act until blackjack, stand, bust, or surrender
    player_done_acting = false
    isurance_purchased = false
    
    # check for blackjack (initial 21 with only 2 cards)  if we find a blackjack, we can skip player actions
    player.current_hand_values.each do |chv|
      if chv == 21
        player_done_acting = true
        self.outcome = :blackjack
      end
    end
    
    until player_done_acting == true
      
			menu_number_possibilities = player.generate_array_of_selectable_menu_numbers()
      selection = menu_number_possibilities[rand(menu_number_possibilities.length)]
      
      # player selection has been made and validated
      
      # record action
      self.gamestates.last.player_action = selection
      
      case selection
        
        when /stand/, 1
          player_done_acting = true
        
        when /hit/, 2
          player.cards << shoe.deal_card()
          
        when /double/, 3
          player.place_bet(house.current_bet, house)
          player.cards << shoe.deal_card()
          player_done_acting = true
        
        when /insurance/, 4
          # place insurance side-bet.  only possible if dealer is showing an ace and only if available via the ruleset
          player.funds -= ruleset.minimum_bet
          insurance_purchased = true
          # only possible once per hand
          player.possible_actions.delete_if {|action| action =~ /insurance/}
          
        when /surrender/, 5
          player_done_acting = true
          self.outcome = :surrender
      
        when /split/, 6
          # todo
          
      end
      # current player action completed

      # after player action has been selected, recorded, and conducted, append a new gamestate & update it
      gamestate = Gamestate.new
      self.gamestates << gamestate
      self.gamestates.last.update_gamestate(house, player)
      
      # calculate possible hand values
      player.calculate_current_hand_values()
      house.calculate_current_hand_values() 
      
      # check game conditions and set player_done_acting = true if player bust or if player has 21
      if player.current_hand_values.min > 21
        player_done_acting = true
        self.outcome = :player_loss      
      else 
        player.current_hand_values.each do |chv|
          if chv == 21
            player_done_acting = true
          end
        end
      end
    
      # after the first move, the only available actions are hit and stand or insurance if available
      player.possible_actions.delete_if {|action| action !~ /hit|stand|insurance/}  
    end  
    # player is now done acting
    
    #______________________________________________________________________________________________#
   
    # once player is done acting, set house_card_hidden to false (i.e. house flips over card)
    house.house_card_hidden = false
    house.calculate_current_hand_values() 
    
    # house to act: (dealer script)

      # check for soft 17
      soft_17 = false
      
      if ruleset.house_hits_soft_17 == true && house.current_hand_values.max == 17
        house.cards.each do |card|
          if card.name =~ /a/i
            soft_17 = true
          end
        end     
      end

      
      # dealer takes cards until dealer script conditions are met 
      until ( house.current_hand_values.max >= 17 || self.outcome != nil ) && soft_17 == false
        house.cards << shoe.deal_card()
        self.gamestates.last.update_gamestate(house, player)
        house.calculate_current_hand_values()
       
           
        # check for soft 17
        if ruleset.house_hits_soft_17 == true
          soft_17 = false
          if house.current_hand_values.max == 17
            house.cards.each do |card|
              if card.name =~ /a/i
                soft_17 = true
              end
            end
          end         
        end
       
        # before testing house current hand values, remove values that would cause bust if there is at least one value under 21
        if house.current_hand_values.length > 1 && house.current_hand_values.min < 21
          house.current_hand_values.delete_if {|current_hand_value| current_hand_value > 21}
        end
      end
    
    # calculate final hand values 
    player.calculate_current_hand_values()
    house.calculate_current_hand_values()
    
      
    # if the lowest possible value of the player's hand is > 21, the player busts
    if player.current_hand_values.min > 21
      self.outcome = :player_loss
      
    # else if the house is bust, the player wins
    elsif house.current_hand_values.min > 21
      self.outcome = :player_win
    
    # otherwise, handle push, player non-blackjack win and player non-bust loss, unless player has already surrendered
    elsif self.outcome !~ /surrender/ 
      # since we have come this far and already checked for blackjack and player/house busts we can remove possible hand values above 21 from consideration
      player.current_hand_values.delete_if {|chv| chv > 21}
      house.current_hand_values.delete_if {|chv| chv > 21}
      
      # handle push
      if player.current_hand_values.max == house.current_hand_values.max
        self.outcome = :push
      
      # handle win
      elsif player.current_hand_values.max > house.current_hand_values.max && self.outcome !~ /blackjack/
        self.outcome = :player_win
      
      # handle loss
      elsif house.current_hand_values.max > player.current_hand_values.max
        self.outcome = :player_loss
      
      end
        
    end
      
    # set final bet value
    self.final_bet_value = self.gamestates.last.bet
    
    # handle game outcome (i.e.  payout/bet/funds for house and player)
    puts
    case self.outcome
      
      when /blackjack/
        # increase current bet in anticipation of payout
        house.current_bet +=  house.current_bet + (house.current_bet * ruleset.payout_ratio).to_i
        # subtract current bet from house funds
        house.funds -=  house.current_bet
        # add current bet to player funds
        
        player.funds += house.current_bet

        
      when /player_win/

        # double current bet in anticipation of payout
        house.current_bet += house.current_bet
        # subtract current bet from house funds
        house.funds -= house.current_bet
        # add current bet to player funds
        player.funds += house.current_bet
        
      when /player_loss/

        house.funds += house.current_bet
        
      when /push/

        player.funds += house.current_bet
      
      when /surrender/

        player.funds += house.current_bet / 2
        house.funds += house.current_bet / 2
        
    end
    
    # zero current bet
    house.current_bet = 0
    
    if insurance_purchased == true
      if house.cards.length == 2 && house.current_hand_values.max == 21   # if dealer got blackjack
        player.funds += ruleset.minimum_bet * 2
        house.funds -= ruleset.minimum_bet * 2  

        
      else
        # remember, insurance already purchased above by player
        house.funds += ruleset.minimum_bet

      end
    end
    
    # handle shoe cleanup 
    shoe.total_hands_dealt += 1
    
    # discard cards
    player.cards = []
    player.current_hand_values = []
    house.cards = []
    house.current_hand_values = []
    
    # shuffle if necessary
    shoe.hands_since_shuffle += 1
    if shoe.hands_since_shuffle >= ruleset.hands_between_shuffles || shoe.unplayed_cards.length < 25
      shoe.shuffle()
      shoe.hands_since_shuffle = 0
      shoe.total_shuffles += 1
    end
    
    return self
  end
	
end