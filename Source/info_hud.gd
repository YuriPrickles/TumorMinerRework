class_name info_hud
extends Control
@export var healthbar: ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	healthbar.value = Global.run_info.health
	pass
