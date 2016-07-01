require_relative 'spec_helper'

describe Robot do

  before :each do 
    @robot = Robot.new
  end

  describe "#heal!" do

    it "Should not heal a robot if it is dead" do
      expect(@robot).to receive(:health).and_return(0)
      expect{ @robot.heal!(20) }.to raise_error(StandardError)
    end

    it "Should heal the robot" do 
      @robot.wound(40)
      @robot.heal!(20)
      expect(@robot.health).to eq(80)
    end

  end

end
