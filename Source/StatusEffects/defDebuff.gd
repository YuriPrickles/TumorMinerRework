class_name defDebuff extends StatusEffect

@export var defMod_instance : float = -0.5

func _init(newDuration:float, newStacks:int):
	self.duration = newDuration
	self.current_stacks = newStacks

func process_effect(plr:Player, delta) -> void:
	super.process_effect(plr, delta)
	plr.apply_def_atkMod((defMod_instance * self.current_stacks))
	super.decrease_duration(delta)
