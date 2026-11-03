class_name CopperNode
extends RockNode

func drop_loot():
	Pickup.new_pickup(CopperOre.new(randi_range(2,4)),position)
