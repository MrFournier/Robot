class BoxOfBolts < Item

  def initialize
    super('Box of bolts', 25)
  end

  def feed(target)
    target.heal(20)
  end

end