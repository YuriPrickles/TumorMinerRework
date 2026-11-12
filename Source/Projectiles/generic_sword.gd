class_name GenericSwordProjectile
extends Projectile

@export var sword_texture:Texture2D
@export var sprite: Sprite2D


var rotation_start:float
var swing_time:float

func _ready() -> void:
	super()
	var hypotenuse = sqrt(
		pow(sword_texture.get_size().x,2) + pow(sword_texture.get_size().y,2)
		)
	#sprite.position = Vector2(0,-hypotenuse)
	sprite.offset = sword_texture.get_size() / 2
	sprite.offset.y *= -1
	(collision_shape.shape as RectangleShape2D).size.y = hypotenuse
	collision_shape.position.y = hypotenuse / -2
	rotation_start = velocity.angle() + deg_to_rad(90)
	var plr = Main.instance.get_player()
	plr.current_holding_arm.apex_destination = plr.current_holding_arm.apex_destination.rotated(rotation_start)



func _process(delta: float) -> void:
	super(delta)
	var plr = Main.instance.get_player()
	rotation = plr.current_holding_arm.apex_destination.angle()
	var tween = create_tween()
	tween.tween_property(plr.current_holding_arm, "apex_destination", plr.current_holding_arm.apex_destination.rotated(deg_to_rad(135)) ,swing_time).set_ease(Tween.EASE_OUT)
	tween.tween_callback(destroy)
func movement():
	position = Main.instance.get_player().current_holding_arm.ApexDisplay.global_position

func tick_down(delta:float):
	pass

func on_collide_enemy(enemy:Enemy):
	enemy.hurt(damage,self)
