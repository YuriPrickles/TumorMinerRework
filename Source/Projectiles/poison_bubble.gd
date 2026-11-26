class_name PoisonBubbleProjectile
extends Projectile

func _physics_process(delta: float) -> void:
	super(delta)
	velocity = velocity.move_toward(Vector2.ZERO,delta * 4)
func on_collide_wall():
	destroy()
func on_collide_player(plr:Player) -> bool:
	if super(plr):
		plr.suffer_effect(Poisoned.new(3))
		destroy()
		return true
	return false
func on_collide_enemy(enemy:Enemy) -> bool:
	if super(enemy):
		enemy.suffer_effect(Poisoned.new(3))
		destroy()
		return true
	return false
func get_damage(dmg, target):
	return ElementalType.ET_Poison.new(damage, target)
