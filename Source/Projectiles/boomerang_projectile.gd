class_name BoomerangProj
extends Projectile
@export var sprite: Sprite2D
@export var outer_area: Area2D

var returning:bool = false
var saved_vel_length:float
func _ready() -> void:
	body_entered.connect(
		func(body):
			if body is TileMapLayer:
				on_collide_wall()
	)
	outer_area.body_entered.connect(
		func(body):
			if body is Enemy:
				on_collide_enemy(body as Enemy)
			if body is RockNode:
				on_collide_rock(body as RockNode)
	)
	saved_vel_length = velocity.length()
func _physics_process(delta: float) -> void:
	super(delta)
	hit_enemies_array.clear()
	sprite.rotation += deg_to_rad(25)
	if not returning:
		velocity = velocity.move_toward(Vector2.ZERO,delta * 32)
		if velocity.length() < 0.05:
			returning = true
	else:
		var plr = Main.instance.get_player()
		velocity = position.direction_to(plr.position) * saved_vel_length
		if position.distance_to(plr.position) < 32:
			queue_free()

func on_collide_wall():
	super()
	returning = true
	set_collision_mask_value(3, false)
	velocity *= -1
func on_collide_enemy(enemy:Enemy) -> bool:
	if super(enemy):
		returning = true
		set_collision_mask_value(3, false)
		return true
	return false
