class_name PartContainer
extends Control

var attached_part:Part
@export var part_name: RichTextLabel
@export var points_label: RichTextLabel
@export var icon: TextureRect
@export var button: Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_part(part:Part):
	attached_part = part
	part_name.text=part.name
	points_label.text = "[center]%s" % (part.points)
	icon.texture = part.texture
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
