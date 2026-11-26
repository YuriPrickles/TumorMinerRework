class_name StatusEffect extends Resource

#Reference point for all statuses, editing them here SHOULD affect how they
#act across all enemies and for the player
enum EFFECTS {burned, sulphured, engulfed, poisoned, rusted, cobwebbed, defUp, defDown, atkUp, atkDown, regen}
@export var status : EFFECTS
@export var status_library : Dictionary[EFFECTS, Array]= {
	#effect     : [dmg, duration, maxStacks], Dmg can be used as a debuff modifier
	EFFECTS.burned    : [3, 7, 5],
	EFFECTS.sulphured : [1, 7, 5],
	EFFECTS.engulfed  : [5, 4, 3], #occurs when sulphered+burned
	EFFECTS.poisoned  : [5, 7, 5],
	EFFECTS.rusted    : [0, 15, 3],
	EFFECTS.cobwebbed : [3, 1, 1], #Should only occur when standing on the web
	EFFECTS.defUp     : [0, 10, 3],
	EFFECTS.defDown   : [0, 10, 3],
	EFFECTS.atkUp     : [0, 10, 3],
	EFFECTS.atkDown   : [0, 10, 3],
	EFFECTS.regen     : [5, 10, 3] #Should be used with plr.heal()
}
var duration:float = 0.0
var max_stacks: int = 1
var current_stacks: int = 0

func _init(time:float,stack:int = 1) -> void :
	duration = time
	current_stacks = stack

#TO IMPLEMENT: 
	#For each possible status in the library, if the stackcount is higher than 0
	#add that status, to the 'active_effects' dictionary
	#add it's damage, duration, and stack count for later calculation
	#set stackcount in the LIBRARY to 0 so the stacks won't be added again later
static func add_effect(array:Array[StatusEffect], effect:StatusEffect) -> void :
	if has_effect(array, effect.get_script()):
		for existing_eff in array:
			if effect.get_script() == existing_eff.get_script():
				existing_eff.duration += effect.duration
				existing_eff.current_stacks = min(
					existing_eff.max_stacks,
					effect.current_stacks + existing_eff.current_stacks)
				return
	array.append(effect)
	effect.on_apply(array)
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
static func remove_effect(array:Array[StatusEffect], effect_script:Script) -> void :
	var marked_for_death:StatusEffect
	for eff in array:
		if effect_script == eff.get_script():
			marked_for_death = eff
	if marked_for_death:
		array.erase(marked_for_death)
	marked_for_death = null

func decrease_duration(delta:float) -> void:
	duration -= delta

static func has_effect(array:Array[StatusEffect],effect_script:Script) -> bool:
	for eff in array:
		if eff.get_script() == effect_script:
			return true
	return false
#Resets duration for the given effect
#func reset_duration(target:Dictionary, effect:EFFECTS) -> void :
	#var baseStatus = status_library.get(effect)
	#var plr_statuses
	#if (target.has(effect)):
		#plr_statuses = target.get(effect)
		##plr_statuses[durationInx] = baseStatus[durationInx]
		##target.set(effect, plr_statuses)

#Removes a single stack of the given effect
func consume_stack() -> void :
	current_stacks -= 1

func on_apply(array:Array[StatusEffect]):
	pass

#Reads through and implements ALL applied effects and interactions
func process_effect(plr:Player, delta) -> void :
	if (current_stacks <= 0 or duration <= 0.0):
		remove_effect(plr.plr_statuses, self.get_script())
	pass

#Same as process_effect but for enemy instances
func process_enemy_effect(enemy:Enemy, delta) -> void :
	if (current_stacks <= 0 or duration <= 0.0):
		remove_effect(enemy.enemy_statuses, self.get_script())
	pass
