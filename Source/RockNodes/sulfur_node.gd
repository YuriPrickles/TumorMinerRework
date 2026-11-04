class_name SulfurNode
extends RockNode

func drop_loot():
	Pickup.new_pickup(Sulfur.new(randi_range(2,5)),position)
