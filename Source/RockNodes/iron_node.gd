class_name IronNode
extends RockNode

func drop_loot():
	Pickup.new_pickup(IronOre.new(randi_range(2,4)),position)
