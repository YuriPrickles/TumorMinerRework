class_name GenericSpearProjectile
extends Projectile
var rotation_start:float
var swing_time:float
@export var spear_texture:Texture2D
@export var sprite: Sprite2D
func _ready() -> void:
	super()
	var hypotenuse = sqrt(
		pow(spear_texture.get_size().x,2) + pow(spear_texture.get_size().y,2)
		)
	#sprite.position = Vector2(0,-hypotenuse)
	sprite.offset = spear_texture.get_size() / 2
	sprite.offset.y *= -1
	(collision_shape.shape as RectangleShape2D).size.y = hypotenuse
	collision_shape.position.y = hypotenuse / -2
	rotation_start = velocity.angle()
	rotation = rotation_start + deg_to_rad(90)
	position_offset = velocity * -(sprite.texture.get_size().x / 1)

var rotation_sweep_angle:float = deg_to_rad(135)

var position_offset: Vector2

func _process(delta: float) -> void:
	print(str(position, "   ", Main.instance.get_player().position, "   ", position_offset))
	super(delta)
	var tween = create_tween()
	tween.tween_property(self, "position_offset", ((sprite.texture.get_size().x) * velocity),swing_time/2).set_ease(Tween.EASE_IN)
	tween.tween_callback(
		func():
			var tween2 = create_tween()
			tween2.tween_property(self, "position_offset", velocity * -(sprite.texture.get_size().x )* 4,swing_time/2).set_ease(Tween.EASE_OUT)
			tween2.tween_callback(destroy)
	)
func movement():
	position = Main.instance.get_player().position + position_offset

func tick_down(delta:float):
	pass
