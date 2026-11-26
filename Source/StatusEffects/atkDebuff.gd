class_name atkDebuff extends StatusEffect

@export var atkMod_instance : float = -1.75

func _init(newDuration:float, newStacks:int):
	self.duration = newDuration
	self.current_stacks = newStacks
	max_stacks = 10
	max_duration = 99

func process_effect(plr:Player, delta) -> void:
	super.process_effect(plr, delta)
	super.decrease_duration(delta)
	
	#if (self.duration > 0 && self.current_stacks > 0):
		#plr.apply_plr_atkMod((atkMod_instance * self.current_stacks))

func on_apply(effects:Array[StatusEffect], plr:Player = null, enemy:Enemy = null) -> void :
	if not (plr == null): print("PLAYER ATK HANDLER")
	else : if not (enemy == null) : print("ENEMY ATK HANDLER")
	
	print("ERR: NO ATK BUFF APPLIED")
