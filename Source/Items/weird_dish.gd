class_name WeirdDish
extends Item

func _init(stk:int=1) -> void:
	anim_type = AnimationType.EAT
	max_stack = 20
	use_delay = 0.3
	auto_use = false
	consumable = true
	super(stk)

func use_item(plr:Player) -> bool:
	super(plr)
	plr.heal(40)
	return true
