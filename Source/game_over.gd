extends Control
@export var button: Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.pressed.connect(
		func():
			Global.start_new_run()
			queue_free()
	)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
