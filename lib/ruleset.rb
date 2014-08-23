############################################################################################################################
############################################################################################################################

# Ruleset contains all information about game parameters and rule options/variations

#	Rules are saved in './rules.config' and persist between games and sessions.                                     
# If you edit the rules within the program, your changes will be saved here.                                      
# Alternatively, you can simply make your changes here.                                                           
# This file is loaded at runtime and can be reloaded from within StatJack via the "rules" Menu.                   
#	                                                                                                                
#                                                                                                                 
# For each line, anything to the right of a # will be ignored as a comment.        													      
#	Blank lines will also be ignored.  Rules can be listed in any order.																			      
# Rules are expected to be in the following format:                                                               
# rule_name = value                                                                                               
#                                                                                                                 
# Any rule that is not explicitly declared in this file will revert to the default(s) below                       
# 	(these defaults are based on standards generally found at casinos in Las Vegas)  												      
#                                                                                                                 
#   insurance = false                 # options: true, false                                                      
#   surrender = false                 # options: true, false                                                      
#   payout_ratio = 3/2                # options: any positive ratio                                               
#   number_of_decks = 5               # options: any positive integer between 1 and 1000                          
#   hands_between_shuffles = 10       # options: any positive integer (if the shoe has < 25 cards between hands   
#                                                                      it will automatically re-shuffle)          
#   house_hits_soft_17 = false        # options: true, false                                                      
#   minimum_bet = 10                  # options: any positive integer                                             
#   bet_denomination = 5              # options: any positive integer                                             
#   player_starting_funds = 1000000   # options: any positive integer                                             
#   house_starting_funds = 1000000    # options: any positive integer                                             
#                                                                                                                 

############################################################################################################################
############################################################################################################################


class Ruleset

  def initialize
    @insurance = false
    @surrender = false
    @payout_ratio = (3/2).to_f
    @number_of_decks = 5
    @hands_between_shuffles = 10
    @house_hits_soft_17 = false
    @minimum_bet = 10
    @bet_denomination = 5
    @player_starting_funds = 1000000
    @house_starting_funds = 1000000
  end
  attr_accessor :insurance, :surrender, :payout_ratio, :number_of_decks, :hands_between_shuffles, :house_hits_soft_17, :minimum_bet, :bet_denomination, :player_starting_funds, :house_starting_funds

############################################################################################################################
  
  def load_rules_from_file()
		rule_lines = []
    open('./rules.config', 'r'){ |rules_configuration_file|
    rule_lines = rules_configuration_file.readlines
    rules_configuration_file.close
    }
    
    rule_lines.each do |rule_line|
      # unless rule line is blank, commented out or comprised only of whitespace and/or #
      unless rule_line =~ /^[\s#]*$|^\s*#/
        rule_line.gsub(/#.*/,'')
        rule_line.strip!
        
        case rule_line
          
          when /insurance/i
            rule_line.gsub!(/.*=/,'').strip!
            if rule_line =~ /true/i || rule_line =~ /false/i
              if rule_line =~ /true/i
                self.insurance = true
              elsif rule_line =~ /false/i
                self.insurance = false
              end
              puts "Insurance set to: "+colorize_blue(rule_line)
            end
          
          when /surrender/i
            rule_line.gsub!(/.*=/,'').strip!
            if rule_line =~ /true/i || rule_line =~ /false/i
              if rule_line =~ /true/i
                self.surrender = true
              elsif rule_line =~ /false/i
                self.surrender = false
              end
              puts "Surrender set to: "+colorize_blue(rule_line)
            end
          
          when /payout_ratio/i, /payout\sratio/i
            rule_line.gsub!(/.*=/,'').strip!
            numbers = rule_line.scan(/\d+/)
            if numbers.length == 2
              ratio = numbers[0].to_f / numbers[1].to_f
              unless ratio < 0
                self.payout_ratio = ratio
                puts "Payout Ratio set to: "+colorize_blue(rule_line)
              end
            end
          
          when /number_of_decks/i, /number\sof\sdecks/i
            rule_line.gsub!(/.*=/,'').strip!
            numbers = rule_line.scan(/\d+/)
            if numbers.length == 1
              unless numbers[0].to_i < 1
                self.number_of_decks = numbers[0].to_i
                puts "Number of Decks set to: "+colorize_blue(numbers[0].to_s)
              end
            end
            
          when /hands_between_shuffles/i, /hands\sbetween\sshuffles/i
            rule_line.gsub!(/.*=/,'').strip!
            numbers = rule_line.scan(/\d+/)
            if numbers.length == 1
              unless numbers[0].to_i < 1
                self.hands_between_shuffles = numbers[0].to_i
                puts "Hands Between Shuffles set to: "+colorize_blue(numbers[0].to_s)
              end
            end
            
          when /house_hits_soft_17/i, /house\shits\ssoft\s17/i
            rule_line.gsub!(/.*=/,'').strip!
            if rule_line =~ /true/i || rule_line =~ /false/i
              if rule_line =~ /true/i
                self.house_hits_soft_17 = true
              elsif rule_line =~ /false/i
                self.house_hits_soft_17 = false
              end
              puts "House Hits Soft 17 set to: "+colorize_blue(rule_line)
            end
            
          when /minimum_bet/i, /minimum\sbet/i
            rule_line.gsub!(/.*=/,'').strip!
            numbers = rule_line.scan(/\d+/)
            if numbers.length == 1
              unless numbers[0].to_i < 1
                self.minimum_bet = numbers[0].to_i
                puts "Minimum Bet set to: "+colorize_blue(numbers[0].to_s)
              end
            end
          
          when /bet_denomination/i, /bet\sdenomination/i
            rule_line.gsub!(/.*=/,'').strip!
            numbers = rule_line.scan(/\d+/)
            if numbers.length == 1
              unless numbers[0].to_i < 1
                self.bet_denomination = numbers[0].to_i
                puts "Bet Denomionation set to: "+colorize_blue(numbers[0].to_s)
              end
            end
          
          when /player_starting_funds/i, /player\sstarting\sfunds/i
            rule_line.gsub!(/.*=/,'').strip!
            numbers = rule_line.scan(/\d+/)
            if numbers.length == 1
              unless numbers[0].to_i < 1
                self.player_starting_funds = numbers[0].to_i
                puts "Player Starting Funds set to: "+colorize_blue(numbers[0].to_s)
              end
           end
          
          when /house_starting_funds/i, /house\sstarting\sfunds/i
            rule_line.gsub!(/.*=/,'').strip!
            numbers = rule_line.scan(/\d+/)
            if numbers.length == 1
              unless numbers[0].to_i < 1
                self.house_starting_funds = numbers[0].to_i
                puts "House Starting Funds set to: "+colorize_blue(numbers[0].to_s)
              end
            end
          
        end
      end
    
    end
    
    puts "\nRules initialized (see " + colorize_blue("./rules.config") + ")\n\n\n"
	end

  
############################################################################################################################

  
  def display_ruleset()
    puts colorize_blue("          Rules:\n")
    puts "Insurance              = " + colorize_white(self.insurance.to_s)
    puts "Surrender              = " + colorize_white(self.surrender.to_s)
    puts "Payout Ratio           = " + colorize_white(self.payout_ratio.to_s)
    puts "Number of Decks        = " + colorize_white(self.number_of_decks.to_s)
    puts "Hands Between Shuffles = " + colorize_white(self.hands_between_shuffles.to_s)
    puts "House Hits Soft 17     = " + colorize_white(self.house_hits_soft_17.to_s)
    puts "Minimum Bet            = " + colorize_white("$"+commatize(self.minimum_bet))
    puts "Player Starting Funds  = " + colorize_white("$"+commatize(self.player_starting_funds))
    puts "House Starting Funds   = " + colorize_white("$"+commatize(self.house_starting_funds))
  end

  
############################################################################################################################  
  
  
  def display_rules_menu()
    puts
    puts
    puts "1. "+colorize_blue("edit")+"  |  2. " + colorize_blue("reload")+" rules.config  |  3. "+colorize_blue("restore") +" defaults  |  4. "+colorize_blue("main")+" menu"
    puts
    print "Please enter the name or number of your selection: "
  end


############################################################################################################################

  
  def manage_ruleset()
    loop do     # loop forever (until break is called)   -- NOTE -- to avoid user frustration 'exit' will exit from every sub menu even though it is not displayed as an option
      selection = nil
      failed_input_count = 0
      until selection =~ /^[1234]{1}\.{0,1}$/ || selection =~ /^edit$/ ||selection =~ /^reload\srules\.config$|^reload$/ || selection =~ /^restore\sdefaults*$|^restore$/ || selection =~ /^main\smenu$|^main_menu$|^main$/ || selection =~ /^exit$|^quit$/
      # set selection variable to user input (gets means get string from user input) .strip takes away leading and trailing whitespace and .downcase makes all letters lowercase
        selection = gets.strip.downcase
        # if the selection does not contain a single number between 1 and 6 or one of the menu's keywords/commands (displayed in blue), print an error msg and retry until input is recognized as expected
        if selection !~ /^[1234]{1}\.{0,1}$/ && selection !~ /^edit$/ && selection !~ /^reload\srules\.config$|^reload$/ && selection !~ /^restore\sdefaults*$|^restore$/ && selection !~ /^main\smenu$|^main_menu$|^main$/ && selection !~ /^exit$|^quit$/
           puts "I'm sorry, I didn't recognize your input.\nPlease try again... (a command number or "+colorize_blue("keyword")+" is expected)"
          # for each failed input attempt, increase failed input counter.  every 5th failed input, redisply options in short navigation menu to remind user (since they will likely have been pushed off the top of the console)
          failed_input_count = failed_input_count + 1
          if (failed_input_count % 5) == 0
            Menu.clear_screen()
            self.display_ruleset()
            self.display_rules_menu()
          end
        end

      end
      
      # if selection contains 1 or more digits, convert it to an integer
      if selection =~ /\d+/
        selection = selection.to_i
      end
      
      
      #todo
      # selection has been validated above, now use case statement to return to edit the rules via the console, reload rules.config, or restore defaults (by creating a new ruleset =>   default_ruleset = Ruleset.new  and then calling default_ruleset.write_rules_to_file() )
      # for Chervine
      # currently function will just echo validated input in an infinite loop
      # see main menu case statement for structure
      # Process.exit can be used to exit the program.
      
      case selection
      
        when /main\smenu|main_menu|main/, 4
          Menu.clear_screen()
          break
        
        when /^exit$|^quit$/
            Menu.display_exit_menu()
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
            
            Menu.clear_screen()
         
            # respond to user selection
            case selection
              when /^exit$|^quit$|^exit\sprogram$|^quit\sprogram$/, 1
                puts colorize_blue("Goodbye!")
                Process.exit
                
              when /^return$|^return\sto\smain\smenu$|^main\smenu$/, 2
                break
              
              when /^cancel$/, 3
                # do nothing
          
            end
      
      end

    end
  end

  
############################################################################################################################
  
  
  def write_rules_to_file()
    open('./rules.config', 'w'){ |rules_configuration_file|
    
      rules_configuration_file.puts"
###################################################################################################################################################
###################################################################################################################################################

#	Rules are saved in './rules.config' and persist between games and sessions.                                     
# If you edit the rules within the program, your changes will be saved here.                                      
# Alternatively, you can simply make your changes here.                                                           
# This file is loaded at runtime and can be reloaded from within StatJack via the 'rules' Menu.                   
#	                                                                                                                
#                                                                                                                 
# For each line, anything to the right of a # will be ignored as a comment.        													      
#	Blank lines will also be ignored.  Rules can be listed in any order.																			      
# Rules are expected to be in the following format:                                                               
# rule_name = value                                                                                               
#                                                                                                                 
# Any rule that is not explicitly declared in this file will revert to the default(s) below                       
# 	(these defaults are based on standards generally found at casinos in Las Vegas)  												      
#                                                                                                                 
#   insurance = false                 # options: true, false                                                      
#   surrender = false                 # options: true, false                                                      
#   payout_ratio = 3/2                # options: any positive ratio                                               
#   number_of_decks = 5               # options: any positive integer between 1 and 1000                          
#   hands_between_shuffles = 10       # options: any positive integer (if the shoe has < 25 cards between hands   
#                                                                      it will automatically re-shuffle)          
#   house_hits_soft_17 = false        # options: true, false                                                      
#   minimum_bet = 10                  # options: any positive integer                                             
#   bet_denomination = 5              # options: any positive integer                                             
#   player_starting_funds = 1000000   # options: any positive integer                                             
#   house_starting_funds = 1000000    # options: any positive integer                                             
#                                                                                                                 

###################################################################################################################################################
###################################################################################################################################################

insurance = #{self.insurance.to_s}          
surrender = #{self.surrender.to_s}          
payout_ratio = #{self.payout_ratio.round(2).to_s}     
number_of_decks = #{self.number_of_decks.to_s}        
hands_between_shuffles = #{self.hands_between_shuffles.to_s}
house_hits_soft_17 = #{self.house_hits_soft_17.to_s}
minimum_bet = #{self.minimum_bet.to_s}
bet_denomination = #{self.bet_denomination.to_s}
player_starting_funds = #{self.player_starting_funds.to_s}
house_starting_funds = #{self.house_starting_funds.to_s}"
 
    rules_configuration_file.close
    }
  end

  
############################################################################################################################
############################################################################################################################
end