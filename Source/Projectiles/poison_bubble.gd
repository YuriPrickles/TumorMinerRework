class_name PoisonBubbleProjectile
extends Projectile

func _process(delta: float) -> void:
	super(delta)
	velocity = velocity.move_toward(Vector2.ZERO,delta * 4)
func on_collide_wall():
	destroy()
func on_collide_player(plr:Player) -> bool:
	if super(plr):
		destroy()
		return true
	return false
