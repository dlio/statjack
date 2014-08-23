############################################################################################################################
############################################################################################################################

# the shoe represents one or more decks
# the shoe will handle all card transactions, dealing and shuffling
# additionally, the shoe will record some metrics which will subsequently be sent to the results class for recording (total hands dealt, total cards dealt)

############################################################################################################################
############################################################################################################################


class Shoe

	def initialize
		@unplayed_cards = []
		@played_cards = []
		@total_hands_dealt = 0
    @total_cards_dealt = 0
	  @hands_since_shuffle = 0
    @total_shuffles = 0
	end
	attr_accessor :unplayed_cards, :played_cards, :total_hands_dealt, :total_cards_dealt, :hands_since_shuffle, :total_shuffles

############################################################################################################################

  def add_decks(number_of_decks)
    # fill a shoe object with a given number of decks of cards
    deck = Deck.new
    number_of_decks.times do
      deck.cards.each do |card|
        self.unplayed_cards << card
      end
    end
  end


############################################################################################################################
  
	
	def shuffle()
    self.played_cards.each do |card|
      self.unplayed_cards << card
    end
		self.unplayed_cards.shuffle!
	end


############################################################################################################################
	
  
	def deal_card()
    card = self.unplayed_cards.pop
	  self.played_cards << card
		self.total_cards_dealt += 1
	  return card
	end


############################################################################################################################
############################################################################################################################
end