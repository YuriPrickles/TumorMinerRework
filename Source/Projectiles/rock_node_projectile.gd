class_name RockNodeProjectile
extends Projectile
@export var sprite: Sprite2D

@export var rock_node:RockNode
@export var animation_player: AnimationPlayer

func _ready() -> void:
	super()
	animation_player.play("wee")
var tween_start:bool=false
func _physics_process(delta: float) -> void:
	super(delta)
	if not rock_node:
		return
	if not tween_start:
		tween_start = true
		var tween = create_tween()
		tween.tween_property(self,"position",rock_node.position,1)
	if not sprite.texture:
		sprite.texture = rock_node.sprite.texture
	if position.distance_to(rock_node.position) <= 4:
		destroy()
		Main.instance.current_floor.rock_nodes.add_child(rock_node)

func on_collide_enemy(enemy:Enemy) -> bool:
	return false
func on_collide_player(plr:Player) -> bool:
	return false
