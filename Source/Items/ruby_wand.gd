class_name RubyWand
extends Item

func _init(stk:int=1) -> void:
	max_stack = 20
	type = Type.WEAPON
	anim_type = AnimationType.PICKAXE
	use_delay = 0.3
	damage = 2
	auto_use = true
	super(stk)

const ember = preload("res://Source/Projectiles/ember.tscn")
func use_item(plr:Player) -> bool:
	var flr : Floor = Main.instance.current_floor
	var vel: Vector2 = plr.aim_to_mouse() * 7
	var proj : Projectile = Projectile.new_projectile(ember,plr.position,vel,damage + plr.get_plr_Atk())
	proj.hostile = false
	await super(plr)
	return true


	
func add_recipes():
	var recipe = Recipe.new()
	recipe.add_ingredient(Ruby, 1)
	recipe.add_ingredient(CopperBar, 3)
	recipe.add_ingredient(Wood, 4)
	recipe.add_ingredient(Rock, 2)
	recipe.set_result(RubyWand.new())
	recipe.register()
