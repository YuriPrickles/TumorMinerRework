class_name Fly
extends Enemy

var chasing:bool = false
@export var detection_range: Area2D
func _ready() -> void:
	super()
	enemy_sprite.animate("idle")
	detection_range.body_entered.connect(
		func(body):
			if body is Player:
				chasing = true
				movement_speed = 300
	)
	detection_range.body_exited.connect(
		func(body):
			if body is Player:
				movement_speed = 600
	)

func _physics_process(delta: float) -> void:
	enemy_sprite.sprite.flip_h = sign(velocity.x) > 0
	if chasing:
		basic_movement(delta)
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		move_and_collide(velocity * delta)

func on_collide_player(plr:Player):
	plr.hurt(3, position)
	on_hurt(0,plr)
