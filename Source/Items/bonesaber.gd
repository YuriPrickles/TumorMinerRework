class_name Bonesaber
extends Item

func _init(stk:int=1) -> void:
	type = Type.WEAPON
	anim_type = AnimationType.INVISIBLE
	use_delay = 0.4
	damage = 2
	super(stk)

const sword = preload("res://Source/Projectiles/generic_sword.tscn")
func use_item(plr:Player) -> bool:
	var proj:GenericSwordProjectile = Projectile.new_projectile(sword,plr.position,plr.aim_to_mouse(),damage)
	proj.swing_time = use_delay
	await super(plr)
	return true

func add_recipes():
	var recipe = Recipe.new()
	recipe.add_ingredient(Rock, 2)
	recipe.add_ingredient(CopperOre, 2)
	recipe.set_result(Bonesaber.new())
	recipe.register()
