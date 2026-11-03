class_name Bat
extends Enemy
@export var detection_range: Area2D
@export var bite_range: Area2D

var chasing:bool = false
var doing_bite_attack = false
var plr_in_bite_range = false
var bite_cooldown_timer:float = 0
const BITE_COOLDOWN:float = 5

func _ready() -> void:
	super()
	detection_range.body_entered.connect(
		func(body):
			if body is Player:
				chasing = true
	)
	detection_range.body_exited.connect(
		func(body):
			if body is Player:
				chasing = false
	)
	bite_range.body_entered.connect(
		func(body):
			if body is Player:
				if not doing_bite_attack and bite_cooldown_timer <= 0:
					start_bite()
	)
	bite_range.body_exited.connect(
		func(body):
			if body is Player:
				plr_in_bite_range = false
	)

func _process(delta: float) -> void:
	if bite_cooldown_timer > 0:
		bite_cooldown_timer -= delta
func _physics_process(delta: float) -> void:
	enemy_sprite.sprite.flip_h = sign(velocity.x) > 0
	if chasing and not doing_bite_attack:
		basic_movement(delta)
	else:
		velocity = override_velocity
		move_and_collide(velocity * delta)
var override_velocity:Vector2
func start_bite():
	var plr : Player = Main.instance.get_player()
	plr_in_bite_range = true
	doing_bite_attack = true
	enemy_sprite.animate("pre_bite")
	override_velocity = position.direction_to(plr.position) * (3 * movement_speed)
	await enemy_sprite.animation_player.animation_finished
	enemy_sprite.animate("bite")
	override_velocity = Vector2.ZERO
	await enemy_sprite.hit
	if plr_in_bite_range:
		plr.hurt(19, position)
	await enemy_sprite.animation_player.animation_finished
	enemy_sprite.animate("idle")
	bite_cooldown_timer = BITE_COOLDOWN
	doing_bite_attack = false

func on_collide_player(plr:Player):
	plr.hurt(7, position)
	enemy_sprite.animate("hurt")
