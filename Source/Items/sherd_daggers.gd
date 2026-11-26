class_name SherdDaggers
extends Item

func _init(stk:int=1) -> void:
	type = Type.WEAPON
	anim_type = AnimationType.INVISIBLE
	use_delay = 0.2
	damage = 8
	super(stk)

const sword = preload("res://Source/Projectiles/sherd_dagger.tscn")
func use_item(plr:Player) -> bool:
	var proj:GenericSwordProjectile = Projectile.new_projectile(sword,plr.position,plr.aim_to_mouse(),damage + plr.get_plr_Atk())
	proj.swing_time = use_delay
	await super(plr)
	proj = Projectile.new_projectile(sword,plr.position,plr.aim_to_mouse(),damage)
	proj.swing_time = use_delay
	proj.rotation_start -= deg_to_rad(270)
	proj.rotation_sweep_angle = deg_to_rad(-135)
	return true

func add_recipes():
	var recipe = Recipe.new()
	recipe.add_ingredient(CopperBar, 2)
	recipe.add_ingredient(TerracottaPot, 1)
	recipe.set_result(SherdDaggers.new())
	recipe.register()
