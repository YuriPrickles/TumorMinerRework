class_name Boomerang
extends Item

func _init(stk:int=1) -> void:
	anim_type = AnimationType.INVISIBLE
	max_stack = 1
	use_delay = 0.3
	auto_use = true
	damage = 8
	super(stk)

var rangproj:BoomerangProj

const rang = preload("res://Source/Projectiles/boomerang_projectile.tscn")

func can_use_item() -> bool:
	if super() and not rangproj:
		return true
	return false

func use_item(plr:Player) -> bool:
	super(plr)
	rangproj = Projectile.new_projectile(rang,plr.position,plr.aim_to_mouse() * 18,damage)
	return true

func add_recipes():
	var recipe = Recipe.new()
	recipe.add_ingredient(Wood,7)
	recipe.register()
