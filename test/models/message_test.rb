require "test_helper"

class MessageTest < ActiveSupport::TestCase
  test "is valid with content up to 1000 characters" do
    message = messages(:one)
    message.content = "a" * 1000

    assert message.valid?
  end

  test "is invalid without content" do
    message = messages(:one)
    message.content = " "

    assert_not message.valid?
  end

  test "is invalid when content exceeds 1000 characters" do
    message = messages(:one)
    message.content = "a" * 1001

    assert_not message.valid?
  end
end
