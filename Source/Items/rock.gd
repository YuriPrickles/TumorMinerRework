class_name Rock
extends Item

func _init(stk:int=1) -> void:
	anim_type = AnimationType.INVISIBLE
	max_stack = 50
	use_delay = 0.3
	consumable = true
	damage = 3
	super(stk)
	
const rock = preload("res://Source/Projectiles/rock_projectile.tscn")
func use_item(plr:Player) -> bool:
	super(plr)
	Projectile.new_projectile(rock,plr.position,plr.aim_to_mouse() * 4,damage)
	await plr.held_item.animation_hit
	return true
