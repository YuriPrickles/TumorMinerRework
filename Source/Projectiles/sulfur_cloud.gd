class_name SulfurCloudProj
extends Projectile
var duration:float = 3
@export var gpu_particles_2d: GPUParticles2D

func on_collide_player(plr:Player) -> bool:
	if super(plr):
		plr.suffer_effect(Sulfured.new(duration))
		return true
	return false
func on_collide_enemy(enemy:Enemy):
	if super(enemy):
		enemy.suffer_effect(Sulfured.new(duration))
		return true
	return false

func get_damage(dmg, target):
	return ElementalType.ET_Sulfur.new(damage, target)
