require "gr-logger/version"
require "logger"

#
# Class GR-AbstractLogger is the basic for other logger.
#
class GRAbstractLogger

  # class instance variables
  attr_reader :class_name 
  
  #
  # initialize method with the name of logger
  #
  def initialize(name)
    @class_name = name
    
  end

  # -==========================================-
  # Class methods
  # -==========================================-

  # -------------------------------------
  # to_s(tring) method
  #
  def to_s
    "#{self.class} for #{@class_name}."
  end

  # -------------------------------------
  # equal? method
  #
  def ==(other)
    
    # check type and class name
    if ( other.instance_of?(GRLogger) && other.class_name === @class_name )
      true  
    # no same class
    else
      false
    end
  end
  
  # eql? method. More strong than above.
  def eql?(other)
    if (other.object_id == self.object_id)
      true
    else
      false
    end
  end

  # -------------------------------------
  # hash method
  #
  def hash()
    # choose a number, for now 31 is fixed
    prime_number = 31

    # class name is not empty or null
    if @class_name.to_s != ''
      prime_number * @class_name.to_s.hash

      # class name is null or empty
    else
      prime_number * self.object_id
    end
    
  end

  # -==========================================-
  # Operative methods
  # -==========================================-
  
  #
  # Log method with level and message
  #
  def log(level, message)
  end
  
  #
  # Log method with level, message and replacement
  #
  def log_replacement(level, message, *replacement)
  end

end