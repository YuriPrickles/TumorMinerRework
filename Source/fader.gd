class_name Fader
extends ColorRect
@export var animation_player: AnimationPlayer

signal faded_in
signal faded_out

func fade_in():
	get_tree().paused = true
	animation_player.play("fade_in")
	await animation_player.animation_finished
	faded_in.emit()

func fade_out():
	get_tree().paused = false
	animation_player.play("fade_out")
	await animation_player.animation_finished
	faded_out.emit()
