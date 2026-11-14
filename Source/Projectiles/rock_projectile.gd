extends Projectile

func on_collide_wall():
	destroy()
func on_collide_enemy(enemy:Enemy):
	destroy()
	enemy.hurt(damage,self)
	return true
