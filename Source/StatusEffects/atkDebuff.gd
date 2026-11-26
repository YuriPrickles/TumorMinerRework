class_name atkDebuff extends StatusEffect

var atkMod_instance : float = -1.75

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
	print(plr)
	print(enemy)
	if not (plr == null): 
		print("PLAYER ATK HANDLER")
		plr.apply_plr_atkMod(self.current_stacks * atkMod_instance)
		return
	else : if not (enemy == null) : 
		print("ENEMY ATK HANDLER")
		enemy.setEnemy_atk(atkMod_instance * self.current_stacks)
		return
	print("ERR: NO ATK BUFF APPLIED")

func on_remove(plr:Player=null, enemy:Enemy=null) -> void :
	if not (plr==null):
		plr.apply_plr_atkMod(self.current_stacks * atkMod_instance * -1)
	else : if not (enemy==null):
		enemy.setEnemy_atk(atkMod_instance * -1)
	else : print("ERR: NO PLR OR ENEMY FOUND")
