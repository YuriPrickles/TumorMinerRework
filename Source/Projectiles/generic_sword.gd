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


func _process(delta: float) -> void:
	super(delta)
	rotation = velocity.angle()
	var tween = create_tween()
	tween.tween_property(self, "rotation", rotation_start + deg_to_rad(135),swing_time).set_ease(Tween.EASE_OUT)
	tween.tween_callback(destroy)
func movement():
	position = Main.instance.get_player().hand_spot.global_position

func tick_down(delta:float):
	pass

func on_collide_enemy(enemy:Enemy):
	enemy.hurt(damage,self)
