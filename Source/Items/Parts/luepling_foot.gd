class_name LueplingFoot
extends Part

func _init(stk:int = 1) -> void:
	super(stk)
	heal_amount = 10
	points = 2

func apply_effects(plr:Player):
	pass

func reset_effect(plr:Player):
	pass
