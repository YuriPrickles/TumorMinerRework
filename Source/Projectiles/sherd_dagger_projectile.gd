class_name SherdDaggerProjectile
extends GenericSwordProjectile

func _ready() -> void:
	super()

func on_collide_enemy(enemy:Enemy) -> bool:
	if super(enemy):
		if randf_range(0,1) < 0.1 :
			Pickup.new_pickup(Clay.new(1),enemy.position)
		return true
	return false
