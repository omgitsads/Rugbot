require 'scamp/plugin'

class CommandListPlugin < Scamp::Plugin
  match "help", :display_command_list
  match "commands", :display_command_list

  def display_command_list context, msg
    max_command_length = command_list.map{|cl| cl.first.to_s }.max_by(&:size).size
    max_adapter_length = command_list.map{|cl| cl[1].join(",").to_s }.max_by(&:size).size
    command_format_string = "%#{max_command_length + 1}s"
    adapter_format_string = "%-#{max_adapter_length + 1}s"
    formatted_commands = command_list.map{|action, adapters, conds| "#{sprintf(command_format_string, action)} | #{sprintf(adapter_format_string, adapters.join(","))} | #{conds.size == 0 ? '' : conds.inspect}"}
    context.say "#{sprintf("%-#{max_command_length + 1}s", "Command match")} | #{sprintf(adapter_format_string, "Adapters")} | Conditions"
    context.say "--------------------------------------------------------------------------------"
    formatted_commands.each {|c| context.say c}
  end

  private
    def command_list
      @bot.matchers.collect do |matcher|
        [matcher.trigger, matcher.on, matcher.conditions]
      end
    end
end
