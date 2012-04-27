#!/usr/bin/env ruby

require 'date'

class ObjectBrowser
  def initialize(object)
    @root_object = object
    @current_object = object
    @expanded_objects = {}
  end

  def print_separator
    puts('================================================================================')
  end

  def read_char
    system("stty raw -echo") 
    char = STDIN.getc
    system("stty -raw echo")

    return char
  end

  def expand_current_object
    @expanded_objects[@current_object] = true;
  end

  def print_object(object, indent)
      puts(
        ("\t" * indent) +
        (object == @current_object ? '> ' : '') + 
        "#{object.to_s}: a #{object.class}"
      )

      if (@expanded_objects[object] == true)
        object.instance_variables.each { |i|
          print_object(i, indent + 1)
          @expanded_objects[i] = false
        }
      end
  end

  def select_previous_object
    previous_object = nil

    @expanded_objects.keys.each { |o| 
      if(@current_object == o && previous_object != nil)
        @current_object = previous_object
        break
      end

      previous_object = o
    }
  end

  def select_next_object 
    previous_object = nil 

    @expanded_objects.keys.each { |o| 
      if(@current_object == previous_object)
        @current_object = o
        break
      end

      previous_object = o
    }
  end

  def run 
    input = ''
    @current_object = @root_object

    while(input != 'Q')
      system("clear")
      puts("Currently Browsing")
      print_separator
      print_object(@root_object, 0)
      print_separator

      input = self.read_char

      case input
      when 'j' then 
        select_next_object
      when 'k' then
        select_previous_object
      when "\r"  then
        expand_current_object
      else
      end
    end

  end
end


if __FILE__ == $0
  date = Date.new()
  
  o = ObjectBrowser.new(date)
  o.run
end
