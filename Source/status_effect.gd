class_name StatusEffect extends Resource


var duration:float = 0.0
var max_duration: float
var max_stacks: int
var current_stacks: int = 0


func _init(time:float,stack:int = 1) -> void :
	duration = time
	current_stacks = stack

#TO IMPLEMENT: 
	#POSSIBLE FIX NEEDED:
		#Might need to add code to check if we're adding to a player or enemys
static func add_effect(array:Array[StatusEffect], effect:StatusEffect, plr:Player=null, enemy:Enemy=null) -> void :
	if has_effect(array, effect.get_script()):
		for existing_eff in array:
			if effect.get_script() == existing_eff.get_script():
				existing_eff.duration = min(
					effect.max_duration, 
					effect.duration + existing_eff.duration)
					
				existing_eff.current_stacks = min(
					existing_eff.max_stacks,
					effect.current_stacks + existing_eff.current_stacks)
				return
			else : print("ERR: UNKNOWN EFFECT")
	array.append(effect)
	effect.on_apply(array, plr, enemy)
	#var baseStatus = status_library.get(effect)
	#var plr_statuses
	#if (target.has(effect)):
		#plr_statuses = target.get(effect)
	#else :
		#plr_statuses = baseStatus
		#plr_statuses[stackInx] = 1
	#
	#if ((plr_statuses[stackInx] < baseStatus[stackInx])): #Target ALREADY HAS a stack
		#plr_statuses = target.get(effect)
		#plr_statuses[stackInx] += 1 #Give target their first stack
		#target.set(effect, plr_statuses)
		#reset_duration(target, effect) #Gained a new stack, refresh duration
	#else : #target DOES NOT HAVE a stack
		#plr_statuses = baseStatus
		#plr_statuses[stackInx] = 1
		#target.set(effect, plr_statuses) #Give Target their first stack

#Entirely removes status from the afflicted target, if they have it
static func remove_effect(array:Array[StatusEffect], effect_script:Script, plr:Player=null, enemy:Enemy=null) -> void :
	var marked_for_death:StatusEffect
	for eff in array:
		if effect_script == eff.get_script():
			marked_for_death = eff
	if marked_for_death:
		marked_for_death.on_remove(plr, enemy)
		array.erase(marked_for_death)
	marked_for_death = null

static func has_effect(array:Array[StatusEffect],effect_script:Script) -> bool:
	for eff in array:
		if eff.get_script() == effect_script:
			return true
	return false

func decrease_duration(delta:float) -> void:
	duration -= delta

#Removes a single stack of the given effect
func consume_stack() -> void :
	current_stacks -= 1

func on_apply(array:Array[StatusEffect], plr:Player = null, enemy:Enemy = null):
	pass

func on_remove(plr:Player=null, enemy:Enemy=null):
	return

func process_effect(plr:Player, delta) -> void :
	if (current_stacks <= 0 or duration <= 0.0):
		remove_effect(plr.plr_statuses, self.get_script(), plr, null)
	pass

#Same as process_effect but for enemy instances
func process_enemy_effect(enemy:Enemy, delta) -> void :
	if (current_stacks <= 0 or duration <= 0.0):
		remove_effect(enemy.enemy_statuses, self.get_script(), null, enemy)
	pass
