class_name SulfurSpider
extends Enemy

@export var detection_range: Area2D
func _ready() -> void:
	super()
	enemy_sprite.animate("idle")
	detection_range.body_entered.connect(
		func(body):
			if body is Player:
				state = State.CHASING
	)
enum State {
	IDLE,
	CHASING,
	SHOOTING,
	DYING
}
var state : State = State.IDLE
var shoot_timer : float = 0.0
const TIME_TO_SHOOT : float = 2.4

var projectile : PackedScene = preload("res://Source/Projectiles/sulfur_ball_projectile.tscn")

func _physics_process(delta: float) -> void:
	super(delta)
	if state == State.DYING: return
	enemy_sprite.sprite.flip_h = sign(velocity.x) > 0
	var plr:Player = Main.instance.get_player()
	if get_current_tile().distance_to(plr.get_current_tile()) <= 6:
		shoot_timer += delta
	if shoot_timer > TIME_TO_SHOOT and state != State.SHOOTING:
		state = State.SHOOTING
		velocity = Vector2.ZERO
		enemy_sprite.force_animate("mortar")
		await enemy_sprite.hit
		shoot_timer = 0
		var plr_dir:Vector2 = position.direction_to(plr.position) * 7
		Projectile.new_projectile(projectile,position,plr_dir)
		state = State.CHASING
		return
	if state == State.CHASING:
		if get_current_tile().distance_to(plr.get_current_tile()) > 4:
			basic_movement(delta)
		else:
			var dir = plr.position.direction_to(position)
			velocity = velocity.move_toward(dir * movement_speed,delta * acceleration)
		
		move_and_slide()
		enemy_sprite.animate("walk")
	else:
		velocity = Vector2.ZERO
		move_and_collide(velocity * delta)



func destroy():
	state = State.DYING
	shoot_timer = -INF
	velocity = Vector2.ZERO
	move_and_slide()
	enemy_sprite.force_animate("death")
	await enemy_sprite.animation_player.animation_finished
	super()

func on_hurt_animation():
	if state != State.SHOOTING or state != State.DYING:
		super()

func react_to_element(type:ElementalType,is_status=false):
	if is_status: return
	if type is ElementalType.ET_Fire:
		suffer_effect(Engulfed.new(2))
		StatusEffect.remove_effect(enemy_statuses, Burned)
	if type is ElementalType.ET_Poison:
		type.damage = -999
		heal(4)
	if type is ElementalType.ET_Sulfur:
		type.damage = max(1, roundi(type.damage * 0.5))
