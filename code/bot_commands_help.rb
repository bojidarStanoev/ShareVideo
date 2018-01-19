
class BotCommandString
  def give_commands_string
    return help_str = "
      commands:
      search keyword => gives you a video based on the given keyword
      ----
      |searchrnd or srcrnd or searchrandom| keyword  => finds a bunch of videos 
      and gives you a random one based on the keyword
      ----
      mostpopular number => gives you mostpopular video from the mostpopular videos on Youtube
      the number indicates which of the 200  most popular videos you want
      ----
      most popular numberX to numberY => returns the most popular videos from numberX to numberY
      ----
      help => returns the bots list of commands
      
      "
  end
end