class_name Poisoned
extends StatusEffect

var DMG_RATE:float:
	get:
		return 1.2 - (0.1 * current_stacks)
var timer : float = 0
var damage : int:
	get:
		return 1 + (current_stacks / 3)
func _init(time:float,stack:int = 1) -> void:
	super(time,stack)
	max_stacks = 9
func process_effect(plr:Player, delta) -> void :
	super(plr,delta)
	timer += delta
	decrease_duration(delta)
	if timer > DMG_RATE:
		plr.knockless_hurt(ElementalType.ET_Poison.new(damage,plr,true))
		timer = 0
func process_enemy_effect(enemy:Enemy, delta) -> void :
	super(enemy,delta)
	timer += delta
	decrease_duration(delta)
	if timer > DMG_RATE:
		enemy.hurt(ElementalType.ET_Poison.new(damage,enemy,true), null)
		timer = 0
