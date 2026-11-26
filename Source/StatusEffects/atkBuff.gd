class_name atkBuff extends StatusEffect

@export var atkMod_instance : float = 1.75


func _init(newDuration:float, newStacks:int):
	self.duration = newDuration
	self.current_stacks = newStacks

func process_effect(plr:Player, delta) -> void:
	super.process_effect(plr, delta)
	plr.apply_plr_atkMod(atkMod_instance * self.current_stacks)
	super.decrease_duration(delta)
