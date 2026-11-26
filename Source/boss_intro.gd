class_name BossIntro
extends Control
@export var timer: Timer

@export var introcard:Sprite2D
@export var animation_player:AnimationPlayer
signal done

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("intro")
	await animation_player.animation_finished
	timer.start()
	await timer.timeout
	animation_player.play("post_intro")
	await animation_player.animation_finished
	queue_free()
	done.emit()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
