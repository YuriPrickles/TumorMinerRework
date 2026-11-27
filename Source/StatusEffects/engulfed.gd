class_name Engulfed
extends StatusEffect

var DMG_RATE:float:
	get:
		return max(0,0.2 - (0.05 * current_stacks))
var timer : float = 0
var damage : int:
	get:
		return 2
func on_apply(array:Array[StatusEffect]):
	if has_effect(array, Sulfured) and has_effect(array, Burned):
		remove_effect(array,Sulfured)
		remove_effect(array,Burned)
func process_effect(plr:Player, delta) -> void :
	super(plr,delta)
	timer += delta
	decrease_duration(delta)
	if timer > DMG_RATE:
		var elm = ElementalType.ET_Fire.new(damage,plr,true)
		elm.color = Color.ORANGE_RED
		plr.knockless_hurt(elm)
		timer = 0
func process_enemy_effect(enemy:Enemy, delta) -> void :
	super(enemy,delta)
	timer += delta
	decrease_duration(delta)
	if timer > DMG_RATE:
		var elm = ElementalType.ET_Fire.new(damage,enemy,true)
		elm.color = Color.ORANGE_RED
		enemy.knockless_hurt(elm)
		timer = 0
