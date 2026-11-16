class_name CrateNode
extends RockNode

func drop_loot():
	Pickup.new_pickup(Wood.new(randi_range(3,5)),position)
	
