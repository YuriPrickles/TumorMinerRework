extends Projectile
func on_collide_player(plr:Player) -> bool:
	if super(plr):
		plr.suffer_effect(Sulfured.new(5))
		destroy()
		return true
	return false
func on_collide_enemy(enemy:Enemy):
	if super(enemy):
		enemy.suffer_effect(Sulfured.new(5))
		destroy()
		return true
	return false

func get_damage(dmg, target):
	return ElementalType.ET_Sulfur.new(damage, target)
