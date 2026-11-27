class_name Audio
extends Node

@export var calm_layer: AudioStreamPlayer
@export var battle_layer: AudioStreamPlayer

@export var boss_intro: AudioStreamPlayer
@export var boss_layer: AudioStreamPlayer
@export var boss_vocals_layer: AudioStreamPlayer


func _ready() -> void:
	initialize_tracks()

func initialize_tracks():
	calm_layer.play()
	battle_layer.play()
	boss_layer.play()
	boss_vocals_layer.play()

func activate_track(track:AudioStreamPlayer):
	var track_arr:Array[AudioStreamPlayer] =[
		calm_layer,battle_layer,boss_layer,boss_vocals_layer
	]
	var tween = create_tween().set_parallel()
	for t in track_arr:
		if track != t:
			tween.tween_property(t,"volume_linear",0,2)
		else:
			tween.tween_property(t,"volume_linear",1,2)
			if t == boss_layer:
				tween.kill()
				for t2 in track_arr:
					t2.stop()
				boss_intro.play()
				await boss_intro.finished
				boss_layer.volume_linear = 1
				boss_vocals_layer.volume_linear = 1
				initialize_tracks()

func _process(delta: float) -> void:
	pass
