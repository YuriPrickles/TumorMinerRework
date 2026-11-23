class_name EmberProjectile
extends Projectile
func on_collide_wall():
	destroy()
func on_collide_player(plr:Player) -> bool:
	if super(plr):
		plr.suffer_effect(StatusEffects.EFFECTS.burned)
		destroy()
		return true
	return false
