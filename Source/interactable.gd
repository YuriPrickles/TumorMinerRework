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

func on_mine(value, plr:Player):
	pass
