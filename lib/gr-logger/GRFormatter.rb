require 'gr-util/gr-util'

#
# Author:: Giorgio Desideri <giorgio.desideri@gmail.com>
#
# Formatter object is the responsible of log message format.
#
# User can define log message format using combination of following pattern:
#
# Time Pattern:
# follow ruby datetime pattern ( https://hackhands.com/format-datetime-ruby/ )
# if didn't specify time pattern, default is ISO 8601 format %Y-%m-%dT%H:%M:%S%z
#
# Message Structure Pattern:
# %severity - log severity
# %caller - logger caller
# %msg - log message. Message can contains '%s' keywords to allow substritution with parameters passed
#
# === Example
#
# Time Pattern "%Y-%m-%d T %H:%M:%S%z"
# Message Pattern "- [%severity] - [ %caller ] - %msg"
#
# Result will be
# >> 2016-02-06 T 11:18:37+0700 - [DEBUG] - [CallerMethod] - message without parameters"
# >> 2016-02-06 T 11:18:37+0700 - [DEBUG] - [CallerMethod] - message with 3 parameters" ( where 3 is a paramter passed with '%s' keyword )
#
# === Note for Developer
#
# 1- To extend this class, override protectedd method 'format_message' and 'format' in case want make more particular the format behavior, for
# example with one specific object that you manage. Here I use 'to_s' method to serialize message as a string.
#
# 2 -
#
class GRFormatter

  SEVERITY_TAG = "%severity"
  CALLER_TAG = "%caller"
  MSG_TAG = "%msg"

  attr_reader :time_pattern, :msg_pattern
  
  # init
  def initialize(time, message)

    # check time
    if(!GRUtil.is_empty?(time))
      # user value
      @time_pattern = String.new(time)
    else
      # default value
      @time_pattern = String.new("%Y-%m-%dT%H:%M:%S%z")
    end

    # check
    if(!GRUtil.is_empty?(message))
      # assign input value
      @msg_pattern = String.new(message)
    else
      # assigne empty string
      @msg_pattern = String.new("")
    end
  end

  # -=======================================================-
  # Protected methods
  # -=======================================================-
  protected

  # format time variable if is needed
  def format_time(time)
    part = time.strftime(@time_pattern)

    if(!GRUtil.is_empty?(part))
      part
    else
      ""
    end
  end

  #
  # method to format message with parameters
  # all inputs parameters are already checked so no need re-check again.
  #
  def format_message(severity, msg, *msg_args)

    # create new string for working copy
    message = String.new(@msg_pattern.to_s)

    # check severity and substitute (linear form)
    message = message.sub(GRFormatter::SEVERITY_TAG.to_s, severity.to_s) if message.include? GRFormatter::SEVERITY_TAG

    # check caller and substitute (extended form)
    if(message.include?(GRFormatter::CALLER_TAG) )then
      callers = caller()[1].to_s

      callers = callers[0, (callers.index(':in'))]
      
      message = message.sub(GRFormatter::CALLER_TAG, callers)
    end

    # check message
    if(message.include?(GRFormatter::MSG_TAG) )then

      # have some parameters
      if(msg_args != nil && msg_args.size() > 0)
        # iterator
        index = -1

        # substitute with
        message = msg.gsub("%s") {|w|  w = msg_args[index+=1] }
      else

        # replace only the message
        message = message.sub(GRFormatter::MSG_TAG, msg)
      end
    end

    message
  end

  # -=======================================================-
  # Public methods
  # -=======================================================-
  public

  # Method that format the message
  def format(severity, message, *msg_args)
    # format time
    msg1 = format_time(Time.now)

    # format message
    msg2 = format_message(severity.to_s, message,*msg_args)

    # return unify of message parts
    msg = msg1 << msg2
  end

end