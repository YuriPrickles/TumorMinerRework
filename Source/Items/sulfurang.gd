class_name Sulfurang
extends Item

func _init(stk:int=1) -> void:
	anim_type = AnimationType.INVISIBLE
	max_stack = 1
	use_delay = 0.7
	auto_use = true
	damage = 6
	super(stk)

var rangproj:SulfurangProj

const rang = preload("res://Source/Projectiles/sulfurang_projectile.tscn")

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
	recipe.add_ingredient(Boomerang,1)
	recipe.add_ingredient(Sulfur,8)
	recipe.register()
