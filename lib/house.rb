############################################################################################################################
############################################################################################################################

# the house class will be responsible only for dealer actions and for managing $ (bets/the current_bet) during gameplay
# dealer actions: hit, stand, collect bet, payout bet
# although this class contains dealer actions, all card management will be handled by the shoe class

############################################################################################################################
############################################################################################################################

class House

	def initialize
	  @cards = []
    @current_hand_values = []
		@funds = nil
    @current_bet = 0
    @house_card_hidden = true
  end
	attr_accessor :cards, :current_hand_values, :funds, :current_bet, :house_card_hidden

############################################################################################################################

  def calculate_current_hand_values()
    self.current_hand_values = []
    ace_count = 0
    first_card = true
    
    self.cards.each do |card|
      
      # evaluate aces
      if card.name =~ /a/i && ace_count == 0 && first_card == true   # if the ace is the first card, add 1 and 11 to possible hand values
        self.current_hand_values << 1
        self.current_hand_values << 11
        ace_count += 1
      elsif card.name =~ /a/i && ace_count == 0 && first_card == false
        starting_chv = self.current_hand_values[0]   # because we have encountered an ace that is not the first card, we need to add both a 1 and an 11 to the current value (which must be singular since an ace has not yet been encountered)
        self.current_hand_values[0] += 1
        self.current_hand_values << starting_chv + 11  
        ace_count += 1        
      elsif card.name =~ /a/i && ace_count > 0      # for all subsequent aces (which will obviously not be the first card) add 1 to all possible current hand values (since 11 + 11 = 22 which would bust, we can never evaluate two aces both at 11)
        (0..self.current_hand_values.length - 1).each do |index|
          self.current_hand_values[index] += 1
        end
        ace_count += 1
        
      # evaluate non-ace face cards
      elsif card.name =~ /[jqk]/i && first_card == true
          self.current_hand_values << 10
      elsif card.name =~ /[jqk]/i && first_card == false
        (0..self.current_hand_values.length - 1).each do |index|
          self.current_hand_values[index] += 10
        end
      
      # evaluate 2-10
      elsif card.name !~ /[jqka]/i && first_card == true
        self.current_hand_values << card.value
      elsif card.name !~ /[jqka]/i && first_card == false    
        (0..self.current_hand_values.length - 1).each do |index|
          self.current_hand_values[index] += card.value
        end
        
      end
      
      # we are no longer on the first card anymore
      first_card = false
      
      # since we have already processed the first card, if the house has a card hidden, only one should have it's value calculated
      if self.house_card_hidden == true
        break
      end
      
    end
    
    self.current_hand_values.sort!
  end

  
############################################################################################################################
############################################################################################################################
end