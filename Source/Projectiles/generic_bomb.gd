class_name GenericBomb
extends Projectile

@export var boom_radius: int = 2
@export var boom_strength: int = 4
@export var fuse_duration : float = 2
@export var destroys_things: bool = true
@export var texture: Sprite2D

var _boom_timer :float = 0.0

func _process(delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, delta * 4)
	texture.rotation_degrees += 1.5 * ( abs(velocity.normalized().length()))
	
	_boom_timer += delta
	if _boom_timer > fuse_duration:
		destroy()
	super(delta)

func on_destroy():
	var flr = Main.instance.current_floor
	
	var plr = Main.instance.get_player()
	if destroys_things:
		for rck in flr.get_rock_nodes():
			if rck.get_current_tile().distance_to(flr.to_tile_grid(position)) <= boom_radius:
				plr.request_mine_action(rck, boom_strength)
		for inter in flr.get_interactables():
			if inter.get_current_tile().distance_to(flr.to_tile_grid(position)) <= boom_radius:
				plr.request_mine_action(inter, boom_strength)
	for enemy in flr.get_enemies():
		if enemy.position.distance_to(position) <= boom_radius * flr.tile_size:
			enemy.hurt(damage, self)
	if flr.to_local_position(plr.get_current_tile()).distance_to(position) <= boom_radius * flr.tile_size:
		plr.hurt(damage, position)
	super()
