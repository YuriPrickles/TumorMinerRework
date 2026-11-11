class_name Pickaxe
extends Item

var strength: int = 1
func _init(stk:int=1) -> void:
	super(stk)
	type = Type.PICKAXE
	auto_use = true
	anim_type = AnimationType.PICKAXE
	use_delay = 0.15

func use_item(plr:Player) -> bool:
	super(plr)
	await plr.held_item.animation_hit
	var c_floor :Floor = Main.instance.current_floor
	var current_tile := plr.get_current_tile()
	var target_tile  := plr.get_targeted_tile()
	for rck in c_floor.get_rock_nodes():
		if target_tile == rck.get_current_tile() or current_tile == rck.get_current_tile():
			plr.request_mine_action(rck, strength)
	for interactable in c_floor.get_interactables():
		if target_tile == interactable.get_current_tile() or current_tile == interactable.get_current_tile():
			plr.request_mine_action(interactable, strength)
	return true
