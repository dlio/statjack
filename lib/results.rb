############################################################################################################################
############################################################################################################################

# Results handles, collects, calculates and stores all statisical measures of gameplay and simulation
# individual game metrics will be stored in gamestates which will be parsed into the variables outlined below at the end of each game
# Also, card and dealing metrics should be collected from the shoe at the end of each game

# what is not yet represented in this class is the decision matrix we will be modeling <to do>

############################################################################################################################
############################################################################################################################

class Results

  def initialize
    @total_games
    @total_shuffles  #include other shoe metrics
    @maximum_bet_size
    @minimum_bet_size
    @average_bet_size
    @player_purse_start_value
    @player_purse_min_value
    @player_purse_max_value
    @player_purse_end_value
    @player_win_count
    @player_loss_count
    @player_funds_won
    @player_funds_lost
    @dealer_purse_start_value
    @dealer_purse_min_value
    @dealer_purse_max_value
    @dealer_purse_end_value
    @dealer_wins
    @dealer_losses
    @house_percent_advantage
  end
  attr_accessor :total_games, :total_shuffles, :maximum_bet_size, :minimum_bet_size, :average_bet_size, :player_purse_start_value, :player_purse_min_value, :player_purse_max_value, :player_purse_end_value, :player_wins, :player_losses, :dealer_purse_start_value, :dealer_purse_min_value, :dealer_purse_max_value, :dealer_purse_end_value, :dealer_wins, :dealer_losses, :house_percent_advantage

  def parse_game(game)
    # here we want to take the gamestates that constitute a single game and read them into the results class, recording all relevant stats
    # here is also where we will begin populating our decision matrix with information about the best decision at any given gamestate
    # if, for example, we have a game where the player won, we look through the gamestates and add the total winnings ($) to each cell that corresponds to
    # an action at a given gamestate that was recorded (e.g. first move: player had a two and a three and hits, add total winnings to the cell that says to hit with a two and a three)
    # for a game where the player lost, subract the total loss (4) from the cell that represents an action at a given gamestate that was recorded
    # e.g. first move: player has a ten and a nine and hits, subtract bet size from the cell that represents a player having a ten and a nine and hitting.
    # after enough iterations, the cells with the highest totals will represent the best decisions at those gamestates/decision points and we will be able to
    # output a decision matrix, along with all of the summary stats outlined above in the initialize statement
  end

  def print_summary_report(file)
    
  end
  
  def print_verbose_report(file)
  
  end
  
end