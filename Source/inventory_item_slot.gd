class_name ItemSlot
extends TextureRect
@export var stack_number: RichTextLabel
@export var color_rect: ColorRect
var selected:bool = false

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	color_rect.color = Color("00000073") if not selected else Color("ffffff73")
