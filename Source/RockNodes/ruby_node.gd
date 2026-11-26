class_name RubyNode
extends RockNode

func drop_loot():
	Pickup.new_pickup(Ruby.new(1),position)
