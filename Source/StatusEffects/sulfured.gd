class_name Sulfured
extends StatusEffect

var DMG_RATE:float:
	get:
		return 1.2 - (0.2 * current_stacks)
var timer : float = 0
var damage : int:
	get:
		return 1
func _init(time:float,stack:int = 1) -> void:
	super(time,stack)
	max_stacks = 5
func on_apply(array:Array[StatusEffect]):
	if has_effect(array, Sulfured) and has_effect(array, Burned):
		remove_effect(array,Sulfured)
		remove_effect(array,Burned)
		add_effect(array,Engulfed.new(duration))
func process_effect(plr:Player, delta) -> void :
	super(plr,delta)
	timer += delta
	decrease_duration(delta)
	if timer > DMG_RATE:
		plr.knockless_hurt(ElementalType.ET_Sulfur.new(damage,plr,true))
		timer = 0
func process_enemy_effect(enemy:Enemy, delta) -> void :
	super(enemy,delta)
	timer += delta
	decrease_duration(delta)
	if timer > DMG_RATE:
		enemy.knockless_hurt(ElementalType.ET_Sulfur.new(damage,enemy,true))
		timer = 0
