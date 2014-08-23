############################################################################################################################
############################################################################################################################

# the player class will contain the player's hand and current $ amount
# methods will represent all possible actions:
#   hit, stand, place insurance bet, split, double down, surrender, place bet

############################################################################################################################
############################################################################################################################


class Player

	def initialize
	  @cards = []
    @current_hand_values = []
		@funds = nil
    @possible_actions = ["stand", "hit", "double_down"]
	end
	attr_accessor :funds, :cards, :current_hand_values, :possible_actions

############################################################################################################################
  
  def place_bet(amount, house)
    self.funds = self.funds - amount
    house.current_bet = house.current_bet + amount
  end

  
############################################################################################################################
  
  
  def hit(shoe)
    self.cards << shoe.deal_card()
  end	

  
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
    end
    
    self.current_hand_values.sort!
  end

   
############################################################################################################################

        
  def generate_array_of_selectable_menu_numbers()
    action_list = String.new
    self.possible_actions.each do |action|
      case action.to_s
        when /stand/
          action_list << "1"
        
        when /hit/
          action_list << "2"
          
        when /double_down/
          action_list << "3"
        
        when /insurance/
          action_list << "4"
        
        when /surrender/
          action_list << "5"
          
        when /split/
          action_list << "6"
        
      end      
    end
    
    # return array of selectable menu numbers
    return action_list.scan(/\d/)
  end

############################################################################################################################
############################################################################################################################
end