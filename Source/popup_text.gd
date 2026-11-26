class_name PopupText
extends Node2D
@export var rich_text_label: RichTextLabel

@export var animation_player: AnimationPlayer
@export var text: String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rich_text_label.text = text
	animation_player.play("sequence")
	await animation_player.animation_finished
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
