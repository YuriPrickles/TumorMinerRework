class_name EmeraldNode
extends RockNode

func drop_loot():
	Pickup.new_pickup(Emerald.new(1),position)
