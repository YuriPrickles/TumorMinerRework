class_name atkDebuff extends StatusEffect

@export var defMod_instance : float = -1.75

func _init(newDuration:float, newStacks:int):
	self.duration = newDuration
	self.current_stacks = newStacks

func process_effect(plr:Player, delta) -> void:
	super.process_effect(plr, delta)
	plr.plrDefMod_apply(defMod_instance)
	super.decrease_duration(delta)
