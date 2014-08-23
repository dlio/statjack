###################################################################################################################
###################################################################################################################

# Menu contains all navigation, menu and sub-menu related functions

# the Menu class works as a singleton 
# only one instance of this object exists throughout the code
# all function are defined with 'def self.function_name'
# function are accessed via Menu.function_name (capital M)
# these functions can be accessed anywhere in the code without needing to do something like menu = Menu.new

# @@ means class variable (1 per class -- accessed via capital M Menu.)

###################################################################################################################
###################################################################################################################

class Menu
  @@display_prompt_for_initial_bet_increase = true
  
  def self.display_prompt_for_initial_bet_increase()
    return @@display_prompt_for_initial_bet_increase
  end
  
  def self.set_display_prompt_for_initial_bet_increase(boolean)
    @@display_prompt_for_initial_bet_increase = boolean
  end
 
################################################################################################################### 
 
  def self.get_main_navigation_selection()  
    selection = nil
    failed_input_count = 0
    until selection =~ /^[123456]{1}\.{0,1}$/ || selection =~ /^play$/ ||selection =~ /^simulate$/ || selection =~ /^results$/ || selection =~ /^rules$|^help$/ || selection =~ /^about$/ || selection =~ /^exit$/i
    # set selection variable to user input (gets means get string from user input) .strip takes away leading and trailing whitespace and .downcase makes all letters lowercase
      selection = gets.strip.downcase
      # if the selection does not contain a single number between 1 and 6 or one of the menu's keywords/commands (displayed in blue), print an error msg and retry until input is recognized as expected
      if selection !~ /^[123456]{1}\.{0,1}$/ && selection !~ /^play$/ && selection !~ /^simulate$/ && selection !~ /^results$/ && selection !~ /^rules$|^help$/ && selection !~ /^about$/i && selection !~ /^exit$/
         puts "I'm sorry, I didn't recognize your input.\nPlease try again... (a command "+colorize_blue("keyword")+" or number is expected)"
        # for each failed input attempt, increase failed input counter.  every 5th failed input, redisply options in short navigation menu to remind user (since they will likely have been pushed off the top of the console)
        failed_input_count = failed_input_count + 1
        if (failed_input_count % 5) == 0
          Menu.clear_screen()
          self.display_navigation_menu()
        end
      end

    end
    # until at start of loop will loop until input is expected
    
    # if selection contains 1 or more digits, convert it to an integer
    if selection =~ /\d+/
      selection = selection.to_i
    end
    
    return selection
  end

  
###################################################################################################################


  def self.display_initial_bet_menu()
    puts "1. "+colorize_blue("yes")+"  |  2. " + colorize_blue("no")+"  |  3. "+colorize_blue("stop")+ " asking me this\n\n"
    print "Increase initial bet for this hand? "
  end

  
###################################################################################################################


  def self.get_initial_bet_menu_selection()
    selection = nil
    failed_input_count = 0
    until selection =~ /^[123]{1}\.{0,1}$|^yes$|^y$|^no$|^n$|^stop$|^s$|^exit$|^quit$|^stop\sasking\sme\sthis$|^stop_asking_me_this$/
      selection = gets.strip.downcase
      if selection !~ /^[123]{1}\.{0,1}$|^yes$|^y$|^no$|^n$|^stop$|^s$|^exit$|^quit$|^stop\sasking\sme\sthis$|^stop_asking_me_this$/
        puts "I'm sorry, I didn't recognize your input.\nPlease try again... (a command "+colorize_blue("keyword")+" or number is expected)"
        # for each failed input attempt, increase failed input counter.  every 5th failed input, redisply options in short navigation menu to remind user (since they will likely have been pushed off the top of the console)
        failed_input_count = failed_input_count + 1
        if (failed_input_count % 5) == 0
          Menu.clear_screen()
          puts "Increase initial bet for this hand?"
          puts "1. "+colorize_blue("yes")+"  |  2. " + colorize_blue("no")+"  |  3. "+colorize_blue("stop")+ " asking me this"
        end
      end
    end
    
    
    # if selection contains 1 or more digits, convert it to an integer
    if selection =~ /\d+/
      selection = selection.to_i
    end
    
    return selection
  end

###################################################################################################################


  def self.display_increase_initial_bet_submenu()
    puts "\nYou may increase your bet of #{commatize(ruleset.minimum_bet)} by increments of #{commatize(ruleset.bet_denomination)}. [#{commatize(ruleset.bet_denomination)}, #{commatize((ruleset.bet_denomination * 2))}, #{commatize((ruleset.bet_denomination * 3))}, etc.]"
    print "By how much would you like to increase your bet?:"
  end
            
#####################################################################
 

  def self.get_increase_initial_bet_value()       
    selection = nil
    failed_input_count = 0
    
    until selection =~ /^\d+$/ && (selection.to_i % ruleset.bet_denomination) == 0 && selection.to_i <= player.funds
      selection = gets.strip.downcase.gsub(/[\$,]/,'')
      
      if selection !~ /^\d+$/ 
        print "\nI'm sorry, I didn't recognize your input.\nPlease try again: "
        # for each failed input attempt, increase failed input counter.  
        failed_input_count = failed_input_count + 1
        selection = nil
      elsif (selection.to_i % ruleset.bet_denomination) != 0
        print "\nI'm sorry, but your input was not an increment of #{commatize(ruleset.bet_denomination)}.\nPlease try again: "
        # for each failed input attempt, increase failed input counter.
        failed_input_count = failed_input_count + 1
      elsif selection.to_i > player.funds
        puts "\nI'm sorry, but that bet would exceed your current funds of: " + colorize_blue("$"+commatize(player.funds))
        print "Please try again: "
        failed_input_count = failed_input_count + 1
      end 
      
      # every 5th failed input, redisply options in short navigation menu to remind user (since they will likely have been pushed off the top of the console)
      if (failed_input_count % 5) == 0
        Menu.clear_screen()
        puts "\nYou may increase your bet of #{commatize(ruleset.minimum_bet)} by increments of #{commatize(ruleset.bet_denomination)}. [#{commatize(ruleset.bet_denomination)}, #{commatize((ruleset.bet_denomination * 2))}, #{commatize((ruleset.bet_denomination * 3))}, etc.]"
        print "By how much would you like to increase your bet?:"
      end
      
    end
    
  end
      
      
#####################################################################
            
            
  def self.display_main_menu()
    puts
    ap "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    puts "                             .------.
          .------.           |"+colorize_white("A")+" .   |
          |"+colorize_red("A")+"_  _ |    .------; / \\  |
          |( \\/ )|-----. _   |(_,_) |
          | \\  / | /\\  |( )  |  I  "+colorize_white("A")+"|
          |  \\/ "+colorize_red("A")+"|/  \\ |_x_) |------'
          `-----+'\\  / | Y  "+colorize_white("A")+"|       
                |  \\/ "+colorize_red("A")+"|-----'       
                `------'    
    "
    ap "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    puts "        "+colorize_title("         StatJack          ")
   
    puts
    puts "1.  " + colorize_blue("play    ") +  "     Play StatJack"
    puts "2.  " + colorize_blue("simulate") +  "     Conduct New Simulation"
    puts "3.  " + colorize_blue("results ") +  "     View Previous Results"
    puts "4.  " + colorize_blue("rules   ") +  "     Rules"
    puts "5.  " + colorize_blue("about   ") +  "     About"
    puts "6.  " + colorize_blue("exit    ") +  "     Exit"
    puts
    print "Please enter the name or number of your selection: "
  end


###################################################################################################################


  def self.display_navigation_menu()
    puts colorize_title("StatJack:")
    puts "1. "+colorize_blue("play")+"  |  2. " + colorize_blue("simulate")+"  |  3. "+colorize_blue("results")+"  |  4. " + colorize_blue("rules")+"  |  5. "+colorize_blue("about")+"  |  6. " + colorize_blue("exit")
    puts
    print "Please enter the name or number of your selection: "
  end


###################################################################################################################


  def self.prompt_for_another_game()
      puts
      puts colorize_white("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
      puts colorize_white("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
      puts
      puts "1. "+colorize_blue("yes")+"  |  2. " + colorize_blue("no")+"  |  6. " + colorize_blue("exit")
      puts
      print "Play Again? "
  end


###################################################################################################################
    

  def self.get_prompt_for_another_game_selection()
    selection = nil
    failed_input_count = 0
      until selection =~ /^[1236]{1}\.{0,1}$|^yes$|^y$|^no$|^n$|^stop$|^s$|^exit$|^quit$/
        selection = gets.strip.downcase
        if selection !~ /^[1236]{1}\.{0,1}$|^yes$|^y$|^no$|^n$|^stop$|^s$|^exit$|^quit$/
          puts "I'm sorry, I didn't recognize your input.\nPlease try again... (a command "+colorize_blue("keyword")+" or number is expected)"
        # for each failed input attempt, increase failed input counter.  every 5th failed input, redisply options in short navigation menu to remind user (since they will likely have been pushed off the top of the console)
        failed_input_count = failed_input_count + 1
        if (failed_input_count % 5) == 0
          self.clear_screen()
          self.display_navigation_menu()
        end
      end

    end
    
    # if selection contains 1 or more digits, convert it to an integer
    if selection =~ /\d+/
      selection = selection.to_i
    end
    
    return selection
  end
  
   
###################################################################################################################


  def self.clear_screen()
    puts "\e[H\e[2J"
  end


###################################################################################################################


  def self.display_about()
    puts colorize_blue("about:")
    puts
    puts colorize_green("                  Version: 0.0.1                   ")
    puts colorize_green("   Authors: David Lio, Chervine Razmazma, Nina Feng")
    puts colorize_green("   10/23/11  | Santa Clara University  | MSIS      ")
    puts colorize_green("                   DLio@scu.edu      ")
    puts
  end


###################################################################################################################


  def self.display_exit_menu()
    puts
    puts "Exit Options:"
    puts "1. "+colorize_blue("exit")+" program  |  2. " + colorize_blue("return")+" to main menu  |  3. "+colorize_blue("cancel")
    puts
    print "Please enter the name or number of your selection: "
  end


###################################################################################################################


  def self.get_exit_menu_selection()
    selection = nil
    failed_input_count = 0
    until selection =~ /^[123]{1}\.{0,1}$/ || selection =~ /^exit$|^quit$|^exit\sprogram$|^quit\sprogram$/ ||selection =~ /^return$|^return\sto\smain\smenu$|^main\smenu$/ || selection =~ /^cancel$/ 
    # set selection variable to user input (gets means get string from user input) .strip takes away leading and trailing whitespace and .downcase makes all letters lowercase
      selection = gets.strip.downcase
      # if the selection does not contain a single number between 1 and 6 or one of the menu's keywords/commands (displayed in blue), print an error msg and retry until input is recognized as expected
      if selection !~ /^[123]{1}\.{0,1}$/ && selection !~ /^exit$|^quit$|^exit\sprogram$|^quit\sprogram$/ && selection !~ /^return$|^return\sto\smain\smenu$|^main\smenu$/ && selection !~ /^cancel$/ 
         puts "I'm sorry, I didn't recognize your input.\nPlease try again... (a command number or "+colorize_blue("keyword")+" is expected)"
        # for each failed input attempt, increase failed input counter.  every 5th failed input, redisply options in short navigation menu to remind user (since they will likely have been pushed off the top of the console)
        failed_input_count = failed_input_count + 1
        if (failed_input_count % 5) == 0
          Menu.clear_screen()
          Menu.display_exit_menu()
        end
      end

    end
    # until at start of loop will loop until input is expected
    
    # if selection contains 1 or more digits, convert it to an integer
    if selection =~ /\d+/
      selection = selection.to_i
    end
  end

  
###################################################################################################################

  
  def self.handle_input_error(error_text)
    ap colorize_red(error_text.to_s)
    open('.\log\error_log.txt', 'a'){ |outfile|
      outfile.puts error_text.to_s
      outfile.close
    }
  end


############################################################################################################################
  
  
  def self.display_possible_actions_menu(player)
    action_items = Array.new
    action_list = String.new
    player.possible_actions.each do |action|

      case action.to_s

        when /stand/
          action_items << "1. "+colorize_blue("stand")+"  |  "
        
        when /hit/
          action_items << "2. "+colorize_blue("hit")+"  |  "
          
        when /double_down/
          action_items << "3. "+colorize_blue("double")+" down  |  "

        when /insurance/
          action_items << "4. "+colorize_blue("insurance")+"  |  "        
        
        when /surrender/
          action_items << "5. "+colorize_blue("surrender")+"  |  "

        when /split/
          action_items << "6. "+colorize_blue("split")+"  |  "
        
      end     
             
    end
    
    action_items.sort!
    
    if action_items.length >= 3
      action_items.insert(3,"\n")
    end   
      
    action_items.each do |action_item|
      action_list << action_item
    end
    
    # remove trailing whitespaces and trailing pipe |
    action_list.gsub!(/[|]([^|]*$)/,'')
    
    puts action_list
    print "\nPlayer Action: "
  end

  
############################################################################################################################


  def self.get_possible_actions_menu_selection(house, player, gamestate)
    selection = nil
    failed_input_count = 0
    selected_action_is_available = nil
    
    until selected_action_is_available == true
    
      until selection =~ /^[123456]{1}\.{0,1}$/ || selection =~ /^stand$/ ||selection =~ /^hit$/ || selection =~ /^double$|^double_down$|^double\sdown$/ || selection =~ /^split$/ || selection =~ /^surrender$/ || selection =~ /^insurance$/ || selection =~ /^exit$|^quit$/
      # set selection variable to user input (gets means get string from user input) .strip takes away leading and trailing whitespace and .downcase makes all letters lowercase
        selection = gets.strip.downcase
        # if the selection does not contain a single number between 1 and 6 or one of the menu's keywords/commands (displayed in blue), print an error msg and retry until input is recognized as expected
        if selection !~ /^[123456]{1}\.{0,1}$/ && selection !~ /^stand$/ && selection !~ /^hit$/ && selection !~ /^double$|^double_down$|^double\sdown$/ && selection !~ /^split$/ && selection !~ /^surrender$/i && selection !~ /^insurance$/ && selection !~ /^exit$|^quit$/
          puts "I'm sorry, I didn't recognize your input.\nPlease try again... (a command "+colorize_blue("keyword")+" or number is expected)"
          print "\nPlayer Action: "
          # for each failed input attempt, increase failed input counter.  every 5th failed input, redisply options in short navigation menu to remind user (since they will likely have been pushed off the top of the console)
          selection = nil
          failed_input_count = failed_input_count + 1
          if (failed_input_count % 5) == 0
            failed_input_count = 0
            Menu.clear_screen()
            gamestate.display_current_gamestate(house, player)
            player.display_possible_actions_menu()
            puts "I'm sorry, I didn't recognize your input.\nPlease try again... (a command "+colorize_blue("keyword")+" or number is expected)"
            print "\nPlayer Action: "
          end
        else
      
          # selection is an action name or number as expected.
          # now check to make sure that action is available to the user

            # by command name
            player.possible_actions.each do |possibility|
              if selection =~ /#{possibility}|exit|quit/
                selected_action_is_available = true
              end
            end
            
            # and by menu number
            selectable_menu_numbers = player.generate_array_of_selectable_menu_numbers()
            selectable_menu_numbers.each do |menu_number|
              if selection =~ /#{menu_number}/
                selected_action_is_available = true
              end
            end
          
          
          if selected_action_is_available != true
            failed_input_count = failed_input_count + 1
            selection = nil
            
            if (failed_input_count % 5) == 0
              failed_input_count = 0
              Menu.clear_screen()
              gamestate.display_current_gamestate(house, player)
              self.display_possible_actions_menu()
            end
            
            puts "I'm sorry, only actions that are displayed are available.\nPlease try again... (a command "+colorize_blue("keyword")+" or number is expected)"
            print "\nPlayer Action: "
         end
        
        end
        
      end
      
    end
    
    # if selection contains 1 or more digits, convert it to an integer
    if selection =~ /\d+/
      selection = selection.to_i
    end
    
    return selection
  end
        
         
###################################################################################################################
###################################################################################################################
end