class_name EnemySprite
extends Node2D

@export var animation_player: AnimationPlayer

##To be used when at like, the "hitting point" of an animation.[br]
##(e.g. The moment an enemy bites or slams a hammer or whatever)
signal hit
@export var sprite: Sprite2D

func animate(anim_name:String):
	if animation_player.is_playing() and animation_player.current_animation != "idle": return
	animation_player.play(anim_name)
	await animation_player.animation_finished

func force_animate(anim_name:String):
	animation_player.play(anim_name)
	await animation_player.animation_finished
