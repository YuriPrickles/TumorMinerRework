extends Projectile
@export var gpu_particles_2d: GPUParticles2D

func _physics_process(delta: float) -> void:
	for i in 50:
		for body in get_overlapping_bodies():
			check_collision(body)
		movement()
	tick_down(delta)

func on_collide_wall():
	destroy()

func destroy():
	on_destroy()
	velocity = Vector2.ZERO
	set_collision_mask_value(4,false)
	gpu_particles_2d.emitting = false
	if lifetime > 3:
		await lifetime_end
	else:
		await get_tree().create_timer(3).timeout
	queue_free()

func get_damage(dmg, target):
	return ElementalType.ET_Water.new(damage, target)
