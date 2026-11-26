class_name Interactable
extends StaticBody2D

@export var main_sprite: Sprite2D
@export var placement_offset = Vector2(32,64)

var in_range:bool = false
var hovered:bool:
	get():
		return Main.instance.get_player().get_targeted_interactable() == self
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func interact(plr:Player):
	pass

func on_detect():
	in_range = true
func on_undetect():
	in_range = false
##Returns a Vector2i position on the tilemap. Use map_to_local to actually do things with it.
func get_current_tile() -> Vector2i:
	var floor :Floor = Main.instance.current_floor
	var tiles :TileMapLayer = floor.current_layout.layout_tiles
	var current_tile := tiles.local_to_map(position)
	return current_tile
	
func on_mine(value, plr:Player):
	pass



func set_outline(value:bool) -> void:
	(main_sprite.material as ShaderMaterial).set_shader_parameter("line_thickness", 0 if not value else 2)
