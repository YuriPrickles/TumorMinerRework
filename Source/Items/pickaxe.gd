class_name Pickaxe
extends Item

var strength: int = 1
func _init(stk:int=1) -> void:
	super(stk)
	type = Type.PICKAXE
	anim_type = AnimationType.PICKAXE
	use_delay = 0.15

func use_item(plr:Player) -> bool:
	super(plr)
	await plr.held_item.animation_hit
	for rck in plr.rocks:
		if rck.in_range and rck.hovered:
			plr.request_mine_action(rck, strength)
	for interactable in plr.interactables:
		if interactable.in_range and interactable.hovered:
			plr.request_mine_action(interactable, strength)
	return true
