class_name Spear
extends Item

func _init(stk:int=1) -> void:
	type = Type.WEAPON
	anim_type = AnimationType.INVISIBLE
	use_delay = 0.4
	damage = 4
	super(stk)

const spear = preload("res://Source/Projectiles/generic_spear.tscn")
func use_item(plr:Player) -> bool:
	var proj:GenericSpearProjectile = Projectile.new_projectile(spear,plr.position,plr.aim_to_mouse(),damage + plr.get_plr_Atk())
	proj.swing_time = use_delay
	await super(plr)
	return true

func add_recipes():
	var recipe = Recipe.new()
	recipe.add_ingredient(Wood, 5)
	recipe.add_ingredient(IronBar, 2)
	recipe.set_result(Spear.new())
	recipe.register()
