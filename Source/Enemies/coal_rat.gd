class_name CoalRat
extends Enemy
@export var detection_range: Area2D
enum State {
	IDLE,
	CHASING,
	DYING
}
var state : State = State.IDLE
var doused : bool = false
func _ready() -> void:
	super()
	detection_range.body_entered.connect(
		func(body):
			if body is Player:
				if is_inital_idle:
					enemy_sprite.force_animate("walk_start")
					await enemy_sprite.animation_player.animation_finished
					enemy_sprite.animate("walk")
					is_inital_idle = false
				state = State.CHASING
	)
	detection_range.body_exited.connect(
		func(body):
			if body is Player:
				state = State.IDLE
	)
var is_inital_idle: bool = true
var ember:PackedScene = preload("res://Source/Projectiles/ember.tscn")
func _physics_process(delta: float) -> void:
	super(delta)
	if state == State.DYING: return
	enemy_sprite.scale.x = -1 if sign(velocity.x) != -1 else 1
	if is_inital_idle and state == State.IDLE:
		enemy_sprite.animate("idle")
	else:
		enemy_sprite.animate("walk")
		if Engine.get_frames_drawn() % 12 == 0:
			var dir = sign(velocity.x)
			if dir == 0: dir = 1
			Projectile.new_projectile(ember, position + Vector2(dir * -72,0), Vector2.ZERO)
	if state == State.CHASING:
		basic_movement(delta)
	else:
		move_and_collide(velocity * delta)

func destroy():
	state = State.DYING
	velocity = Vector2.ZERO
	move_and_slide()
	enemy_sprite.force_animate("explode")
	await enemy_sprite.animation_player.animation_finished
	Main.instance.current_floor.explode_at(position,4,3,12)
	super()

func on_collide_player(plr:Player):
	plr.hurt(ElementalType.ET_Fire.new(7,plr), position)
	enemy_sprite.animate("hurt")
	super(plr)
