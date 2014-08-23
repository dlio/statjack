##########################################
#                                        #
#              StatJack                  #
#	  BlackJack Statistical Simulation     #
#                                      	 #
##########################################
#coding: utf-8

require './lib/requirements.rb'


######################################################################################################################

# main()   i.e if this file was called as itself and not just required by another file
if __FILE__ == $0
  Menu.clear_screen()
  Menu.display_main_menu()
  
  # loop forever
  loop do
    
    selection = Menu.get_main_navigation_selection()
    
    Menu.clear_screen()
 
    # respond to user selection
    case selection
      when /play/, 1
        simulation = Simulation.new
        ruleset = Ruleset.new 
        ruleset.load_rules_from_file()
        
        player = Player.new
        player.funds = ruleset.player_starting_funds
        
        house = House.new
        house.funds = ruleset.house_starting_funds
        
        shoe = Shoe.new
        shoe.add_decks(ruleset.number_of_decks)
        shoe.shuffle()      
        
        loop do
          game = Game.new
          simulation.games << game.play(house, player, ruleset, shoe)
        
          # ask user if they would like to play again
          Menu.prompt_for_another_game()
          selection = Menu.get_prompt_for_another_game_selection()
          
          case selection
            when /yes/, 1
              
            when /no/, 2
              break
                 
            when /exit|quit/, 6   # should be options to 1. exit program 2. return to main menu 3. cancel
              Menu.display_exit_menu()
              selection = Menu.get_exit_menu_selection()
              
              Menu.clear_screen()
           
              # respond to user selection
              case selection
                when /^exit$|^quit$|^exit\sprogram$|^quit\sprogram$/, 1
                  puts colorize_blue("You'll be back.")
                  Process.exit
                  
                when /^return$|^return\sto\smain\smenu$|^main\smenu$/, 2
                  break
                
                when /^cancel$/, 3
                  # do nothing
            
              end
        
            end
            Menu.clear_screen()
          end
        
          # write simulation to log for later results parsing
          simulation.save()
          
      when /simulate/, 2
        puts colorize_blue("simulate:\n")
      
      when /results/, 3
        puts colorize_blue("results:\n")
        
      when /rules|help/, 4
        # initialize temporary ruleset object for rule management
        ruleset = Ruleset.new
        ruleset.load_rules_from_file()        
        Menu.clear_screen()
        
        ruleset.display_ruleset()
        ruleset.display_rules_menu()
        ruleset.manage_ruleset()   # for editing rules, reloading rules.ini and restoring defaults
        
      when /about/, 5
        Menu.display_about()
        
      # when user inputs "exit" or 6, break out of forever loop and reach end of file
      when /exit/, 6
        break
      else
        #this should never be reached, but if it is, log error to error file and output it to the console in red
        Menu.handle_input_error("input_error: unaccounted case in case statement: #{selection}")
      end
    
      Menu.display_navigation_menu()
    
    
  end
end
  
puts colorize_blue("You'll be back.")

