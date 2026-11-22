class_name StatusEffects extends Resource

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
#@export var status_instance = {}
@export var active_effects : Dictionary[EFFECTS, Array] = {
	#effect : [dmg, remainingDuration, remainingStacks]
}

var dmgInx = 0
var durationInx = 1
var stackInx = 2

func _init() -> void :
	return

#TO IMPLEMENT: 
	#For each possible status in the library, if the stackcount is higher than 0
	#add that status, to the 'active_effects' dictionary
	#add it's damage, duration, and stack count for later calculation
	#set stackcount in the LIBRARY to 0 so the stacks won't be added again later
func add_effect(target:Dictionary, effect:EFFECTS) -> void :
	var baseStatus = status_library.get(effect)
	var plrStatus
	if (target.has(effect)):
		plrStatus = target.get(effect)
	else :
		plrStatus = baseStatus
		plrStatus[stackInx] = 1
	
	if ((plrStatus[stackInx] < baseStatus[stackInx])): #Target ALREADY HAS a stack
		plrStatus = target.get(effect)
		plrStatus[stackInx] += 1 #Give target their first stack
		target.set(effect, plrStatus)
		reset_duration(target, effect) #Gained a new stack, refresh duration
	else : #target DOES NOT HAVE a stack
		plrStatus = baseStatus
		plrStatus[stackInx] = 1
		target.set(effect, plrStatus) #Give Target their first stack

#Entirely removes status from the afflicted target, if they have it
func remove_effect(target:Dictionary, effect:EFFECTS) -> void :
	var plrStatus
	if (target.has(effect)):
		plrStatus = target.erase(effect)
	else:
		return

func decrease_duration(target:Dictionary, effect:EFFECTS) -> void:
	var plrStatus = target.get(effect)
	plrStatus[durationInx] -= 1
	if (plrStatus[durationInx] <= 0):
		remove_effect(target, effect)
	else :
		target.set(effect, plrStatus)

#Resets duration for the given effect
func reset_duration(target:Dictionary, effect:EFFECTS) -> void :
	var baseStatus = status_library.get(effect)
	var plrStatus
	if (target.has(effect)):
		plrStatus = target.get(effect)
		plrStatus[durationInx] = baseStatus[durationInx]
		target.set(effect, plrStatus)

#Removes a single stack of the given effect
func consume_stack(target:Dictionary, effect:EFFECTS) -> void :
	var plrStatus
	if (target.has(effect)):
		plrStatus = target.get(effect)
		plrStatus[stackInx] -= 1
		if (plrStatus[stackInx] <= 0) :
			remove_effect(target, effect)
		else :
			target.set(effect, plrStatus)
	else :
		return

#Reads through and implements ALL applied effects and interactions
func process_effect(target:Dictionary, plr:Player) -> void :
	var plrStatus
	var currEffect
	if not (target.size() >= 0) :
		return
	
	currEffect = EFFECTS.engulfed
	if (target.has(EFFECTS.burned) && target.has(EFFECTS.sulphured)):
		plrStatus = target.get(currEffect)
		remove_effect(target, EFFECTS.burned)
		consume_stack(target, EFFECTS.sulphured)
		add_effect(target, currEffect)
		plr.hurt(plrStatus[dmgInx], plr.position, 0)
		decrease_duration(target, currEffect)
		
	currEffect = EFFECTS.burned
	if (target.has(currEffect)):
		plrStatus = target.get(currEffect)
		plr.hurt(plrStatus[dmgInx], plr.position, 0)
		decrease_duration(target, currEffect)
	
	currEffect = EFFECTS.sulphured
	if (target.has(currEffect)):
		plrStatus = target.get(currEffect)
		plr.hurt(plrStatus[dmgInx], plr.position, 0)
		decrease_duration(target, currEffect)
	
	currEffect = EFFECTS.poisoned
	if (target.has(currEffect)):
		plrStatus = target.get(currEffect)
		plr.hurt(plrStatus[dmgInx], plr.position, 0)
		decrease_duration(target, currEffect)
	
	currEffect = EFFECTS.regen
	if (target.has(currEffect)):
		plrStatus = target.get(currEffect)
		decrease_duration(target, currEffect)
		plr.heal(plrStatus[dmgInx])
	
	return

#Same as process_effect but for enemy instances
func process_enemy_effects(target:Dictionary, enemy:Enemy) -> void :
	var enemyStatus
	var currEffect
	if not (target.size() >= 0) :
		return
	
	currEffect = EFFECTS.engulfed
	if (target.has(EFFECTS.burned) && target.has(EFFECTS.sulphured)):
		enemyStatus = target.get(currEffect)
		remove_effect(target, EFFECTS.burned)
		consume_stack(target, EFFECTS.sulphured)
		add_effect(target, currEffect)
		enemy.hurt(enemyStatus[dmgInx], enemy.position)
		decrease_duration(target, currEffect)
		
	currEffect = EFFECTS.burned
	if (target.has(currEffect)):
		enemyStatus = target.get(currEffect)
		enemy.hurt(enemyStatus[dmgInx], enemy.position)
		decrease_duration(target, currEffect)
	
	currEffect = EFFECTS.sulphured
	if (target.has(currEffect)):
		enemyStatus = target.get(currEffect)
		enemy.hurt(enemyStatus[dmgInx], enemy.position)
		decrease_duration(target, currEffect)
	
	currEffect = EFFECTS.poisoned
	if (target.has(currEffect)):
		enemyStatus = target.get(currEffect)
		enemy.hurt(enemyStatus[dmgInx], enemy.position)
		decrease_duration(target, currEffect)
	
	currEffect = EFFECTS.regen
	if (target.has(currEffect)):
		enemyStatus = target.get(currEffect)
		decrease_duration(target, currEffect)
		enemy.heal(enemyStatus[dmgInx])
	return

func store_plr_effects() -> void:
	Global.save_plr_effects(self)
func apply_plr_effects() -> StatusEffects:
	var tempEffects : StatusEffects = Global.load_plr_effects()
	if (tempEffects != null):
		return tempEffects
	
	return StatusEffects.new()
