class_name Burned
extends StatusEffect

var DMG_RATE:float:
	get:
		return 0.5 - (0.12 * current_stacks)
var timer : float = 0
var damage : int:
	get:
		return 2
func process_effect(plr:Player, delta) -> void :
	super(plr,delta)
	timer += delta
	decrease_duration(delta)
	if timer > DMG_RATE:
		plr.knockless_hurt(ElementalType.ET_Fire.new(damage,plr,true))
		timer = 0
func process_enemy_effect(enemy:Enemy, delta) -> void :
	super(enemy,delta)
	timer += delta
	decrease_duration(delta)
	if timer > DMG_RATE:
		enemy.knockless_hurt(ElementalType.ET_Fire.new(damage,enemy,true))
		timer = 0
