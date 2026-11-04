class_name ClayNode
extends RockNode

func drop_loot():
	Pickup.new_pickup(Clay.new(randi_range(1,2)),position)
