class_name HeldItem
extends Sprite2D

@export var animation_player: AnimationPlayer
var animating:bool  = false
signal animation_hit
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	texture = Global.get_current_item().texture if Global.get_current_item() else null
	pass

func do_animation(item:Item):
	animating = true
	match item.anim_type:
		Item.AnimationType.PICKAXE:
			animation_player.get_animation(&"pick_swing").length = item.use_delay
			animation_player.get_animation(&"pick_swing").track_set_key_time(0,1,item.use_delay)
			animation_player.play(&"pick_swing")
			await animation_player.animation_finished
			animation_hit.emit()
			animation_player.play(&"pick_swing_return")
			await animation_player.animation_finished
		Item.AnimationType.EAT:
			animation_player.get_animation(&"eat").length = item.use_delay
			animation_player.get_animation(&"eat").track_set_key_time(0,1,item.use_delay)
			animation_player.play(&"eat")
			await animation_player.animation_finished
			animation_hit.emit()
		Item.AnimationType.INVISIBLE:
			hide()
			animation_hit.emit()
			await get_tree().create_timer(item.use_delay).timeout
			show()
	animating = false
