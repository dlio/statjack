############################################################################################################################
############################################################################################################################

# the card class represents a playing card

############################################################################################################################
############################################################################################################################

class Card

	def initialize
		@suit = nil
    @name = nil
		@value = nil
    @layout = nil
    @symbol = nil
	end
	attr_accessor :suit, :name, :value, :layout, :symbol
  
end