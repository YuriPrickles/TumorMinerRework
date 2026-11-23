class_name SulfurBallProjectile
extends Projectile

func on_collide_wall():
	destroy()

func on_collide_player(plr:Player) -> bool:
	if super(plr):
		plr.suffer_effect(StatusEffects.EFFECTS.sulphured)
		destroy()
		return true
	return false
func on_collide_enemy(enemy:Enemy):
	if super(enemy):
		destroy()
		return true
	return false
