class_name EmberProjectile
extends Projectile
func on_collide_player(plr:Player) -> bool:
	if super(plr):
		destroy()
		return true
	return false
