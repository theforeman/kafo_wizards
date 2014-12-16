require 'test_helper'

describe "KafoWizards::ValidationError" do

  it "accepts message" do
    e = KafoWizards::ValidationError.new("Message")
    e.message.must_equal "Message"
    e.messages.must_equal ["Message"]
  end

  it "accepts list of messages" do
    e = KafoWizards::ValidationError.new(["Message1", "Message2"])
    e.message.must_equal "Message1; Message2"
    e.messages.must_equal ["Message1", "Message2"]
  end

end
