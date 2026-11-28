class_name Bonesaber
extends Item

func _init(stk:int=1) -> void:
	type = Type.WEAPON
	anim_type = AnimationType.INVISIBLE
	use_delay = 0.4
	damage = 5
	super(stk)

const sword = preload("res://Source/Projectiles/generic_sword.tscn")
func use_item(plr:Player) -> bool:
	var proj:GenericSwordProjectile = Projectile.new_projectile(sword,plr.position,plr.aim_to_mouse(),damage + plr.get_plr_Atk())
	proj.swing_time = use_delay
	await super(plr)
	return true

func add_recipes():
	var recipe = Recipe.new()
	recipe.add_health_sacrifice(3)
	recipe.set_result(Bonesaber.new())
	recipe.register()
