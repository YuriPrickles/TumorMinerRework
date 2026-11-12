class_name BatLeg
extends Part

func _init(stk:int = 1) -> void:
	super(stk)
	heal_amount = 20
	points = 2

func apply_effects(plr:Player):
	plr.speed_mult += 1.05

func reset_effect(plr:Player):
	plr.speed_mult -= 1.05
