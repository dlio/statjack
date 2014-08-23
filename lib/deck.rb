############################################################################################################################
############################################################################################################################

# the deck class represents a standard deck of 52 playing cards

############################################################################################################################
############################################################################################################################

class Deck

	def initialize
		@cards = []
		@suits = ["Heart", "Spade", "Diamond", "Club"]
		@names = ["A","2","3","4","5","6","7","8","9","10","J","Q","K"]
		@suits.each do |suit|
			@names.each do |name|
				card = Card.new
				card.suit = suit
				card.name = name
       
        if card.name =~ /[123456789]/
          card.value = card.name.to_i
        elsif card.name =~ /A/i
          card.value = 1
        elsif card.name =~ /[JQK]/i
          card.value = 10
        end
        # set card layout for ascii art reprentation (console display)
        # the extra space after the symbol is needed otherwise only half of the symbol is displayed
        if card.suit == "Heart"
          card.symbol = HTMLEntities.new.decode "&hearts;" + " " # windows only: 3.chr #sybol itself: "♥"
          card.layout = "
 _________ 
/         \
|"+colorize_red(card.name)+"        |
|   _ _   |
|  / ^ \  |
|  \   /  |
|   \ /   |
|    `    |
|        "+colorize_red(card.name)+"|
\_________/"
           
        elsif card.suit == "Spade"
          card.symbol = HTMLEntities.new.decode "&spades;" + " " #6.chr # "♠"
          card.layout = "
 _________ 
/         \
|"+colorize_white(card.name)+"        |
|    ,    |
|   / \   |
|  (_ _)  |
|   /_\   |
|         |
|        "+colorize_white(card.name)+"|
\_________/"
                  
        elsif card.suit == "Diamond"
          card.symbol = HTMLEntities.new.decode "&diams;" + " " #4.chr # "♦"
          card.layout = "
 _________ 
/         \
|"+colorize_red(card.name)+"        |
|    _    |
|   (_)   |
|  (_)_)  |
|   /_\   |
|         |
|        "+colorize_red(card.name)+"|
\_________/"
                   
        elsif card.suit == "Club"
          card.symbol = HTMLEntities.new.decode "&clubs;" + " " #5.chr # "♣"
          card.layout = "
 _________ 
/         \
|"+colorize_white(card.name)+"        |
|   _ _   |
|  / ^ \  |
|  \   /  |
|   \ /   |
|    `    |
|        "+colorize_white(card.name)+"|
\_________/"
                   
        end
        
				@cards << card
			end
		end
    
	end
	attr_accessor :cards

  
############################################################################################################################


	def shuffle()
		self.cards.shuffle!
	end	

  
end
