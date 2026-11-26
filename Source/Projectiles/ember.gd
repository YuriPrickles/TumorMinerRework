class_name EmberProjectile
extends Projectile
func on_collide_wall():
	destroy()
func on_collide_enemy(enemy:Enemy) -> bool:
	if super(enemy):
		enemy.suffer_effect(Burned.new(3))
		destroy()
		return true
	return false
func on_collide_player(plr:Player) -> bool:
	if super(plr):
		plr.suffer_effect(Burned.new(3))
		destroy()
		return true
	return false
func get_damage(dmg, target):
	return ElementalType.ET_Fire.new(damage, target)
