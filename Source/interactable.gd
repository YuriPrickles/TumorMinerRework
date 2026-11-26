class_name Interactable
extends StaticBody2D

@export var  placement_offset = Vector2(32,64)
@export var click_area: Area2D
var in_range:bool = false
var hovered:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	click_area.mouse_entered.connect(func():hovered=true)
	click_area.mouse_exited.connect(func():hovered=false)

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
