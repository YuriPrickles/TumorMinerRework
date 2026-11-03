class_name Part
extends Item

var heal_amount:int
var points:int

func _init(stk:int = 1) -> void:
	if get_item_class_name() != "Part":
		super(stk)
	max_stack = 1
	use_delay = 0.3
	anim_type = AnimationType.EAT
	consumable = true
	stack = 1

func part_effects(plr:Player):
	pass

func reset_effect(plr:Player):
	pass

func use_item(plr:Player) -> bool:
	super(plr)
	await plr.held_item.animation_hit
	plr.heal(heal_amount)
	part_effects(plr)
	Global.run_info.build.parts.append(self)
	return true

func can_use_item() -> bool:
	if not Global.run_info.build.can_fit_capacity(points):
		return false
	return true
