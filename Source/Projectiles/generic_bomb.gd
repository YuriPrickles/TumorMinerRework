class_name GenericBomb
extends Projectile

@export var boom_radius: int = 2
@export var boom_strength: int = 4
@export var fuse_duration : float = 2
@export var destroys_things: bool = true
@export var texture: Sprite2D

var _boom_timer :float = 0.0

func _physics_process(delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, delta * 8)
	texture.rotation_degrees += 1.5 * ( abs(velocity.normalized().length()))
	
	_boom_timer += delta
	if _boom_timer > fuse_duration:
		destroy()
	super(delta)

func on_destroy():
	var flr = Main.instance.current_floor
	var plr = Main.instance.get_player()
	if destroys_things:
		flr.explode_at(position, boom_radius,boom_strength,damage)
	super()

func on_collide_enemy(enemy:Enemy) -> bool:
	return false

func on_collide_wall():
	velocity *= -0.6
