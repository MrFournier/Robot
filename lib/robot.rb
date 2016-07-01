require 'pry'

class Robot

  attr_reader :robot_location, :items, :health

  MAX_WEIGHT = 250
  MAX_HEALTH = 100
  STEP_DISTANCE = 1

  def initialize
    @robot_location = [0, 0]
    @items = []
    @health = MAX_HEALTH
    @weapon = nil
  end

  # Method to find out the position of the robot
  def position
    robot_location
  end

  def move_left
    robot_location[0] -= STEP_DISTANCE
  end

  def move_right
    robot_location[0] += STEP_DISTANCE
  end

  def move_up
    robot_location[1] += STEP_DISTANCE
  end

  def move_down
    robot_location[1] -= STEP_DISTANCE
  end

  def pick_up(item)
    if can_pick_up?(item)
      if item.is_a?(Weapon)
        self.equipped_weapon = item
      elsif item.is_a?(BoxOfBolts) && health <= 80
        item.feed(self)
      else
        items << item
      end
    end
  end

  def items_weight
    total_weight = 0
    items.each {|item| total_weight += item.weight}
    total_weight
  end

  def can_pick_up?(item)
    (items_weight + item.weight) <= MAX_WEIGHT
  end

  def wound(damage)
    @health -= damage
    @health = 0 if health < 0
  end

  def heal(heal)
    @health += heal
    @health = MAX_HEALTH if health > MAX_HEALTH
  end

  def heal!(heal)
    raise StandardError, "robot is dead cannot be revived" if health <= 0
      heal(heal)
  end

  def attack(target)
      if equipped_weapon?
        # Switch the && operands
        if in_range?(target, @weapon.range) && @weapon.is_a?(Grenade)
          @weapon.hit(target)
          unequip_weapon
        elsif in_range?(target, @weapon.range)
          @weapon.hit(target)
        end
      else
        if in_range?(target)
          target.wound(5)
        end
      end
  end

  def attack!(target)
    raise StandardError, "Can only attack robots" unless target.is_a?(Robot)
    attack(target)
  end

  def in_range?(target, range = 1)
    range = range
    target_x = target.position[0]
    target_y = target.position[1]
    current_x = position[0]
    current_y = position[1]
    in_range_x = (current_x == target_x || 
                    current_x + range == target_x || 
                    current_x - range == target_x)
    in_range_y = (current_y == target_y || 
                    current_y + range == target_y || 
                    current_y - range == target_y)

    return false unless in_range_x && in_range_y
    return true
  end

  def equipped_weapon=(new_weapon)
    @weapon = new_weapon
  end

  def equipped_weapon
    @weapon
  end

  def equipped_weapon?
    @weapon != nil 
  end

  def unequip_weapon
    @weapon = nil
  end

end
