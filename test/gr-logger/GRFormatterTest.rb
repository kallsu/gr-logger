require 'gr-logger/GRFormatter'

#
# Author:: Giorgio Desideri <giorgio.desideri@gmail.com>
#
class GRFormatterTest < Test::Unit::TestCase
  def test_format()

    # create formatter
    f = GRFormatter.new(nil, ": [%severity] : %msg : [%caller]")

    # check format
    msg = f.format("INFO", "Hello world !")

    assert_same(true, msg.size > 0)
    assert_same(true, msg.include?("INFO"))
    assert_same(true, msg.include?("Hello world !"))

    # message with parameters
    msg = f.format("TEST", "Messsage with %s parameters [%s]", "2", "TEST_PARAMETER")

    assert_same(true, msg.size > 0)
    assert_same(true, msg.include?("TEST"))
    assert_same(true, msg.include?("Messsage with 2 parameters [TEST_PARAMETER]"))

    # check robustness
    msg = f.format("TEST", "Messsage with %s parameters [%s]")
    assert_same(true, msg.size > 0)
    assert_same(true, msg.include?("TEST"))
    assert_same(true, msg.include?("Messsage with %s parameters [%s]"))
  end

end