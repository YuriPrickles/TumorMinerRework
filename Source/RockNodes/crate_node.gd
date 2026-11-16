class_name CrateNode
extends RockNode

func drop_loot():
	Pickup.new_pickup(Wood.new(randi_range(0,3)),position)

func on_hit_by_projectile(projectile:Projectile):
	on_mine(1, Main.instance.get_player())
