class_name EmeraldWand
extends Item

func _init(stk:int=1) -> void:
	max_stack = 20
	type = Type.WEAPON
	anim_type = AnimationType.PICKAXE
	use_delay = 0.3
	damage = 2
	auto_use = true
	super(stk)

const bubble = preload("res://Source/Projectiles/poison_bubble.tscn")
func use_item(plr:Player) -> bool:
	var flr : Floor = Main.instance.current_floor
	var vel: Vector2 = plr.aim_to_mouse() * 7
	var proj : Projectile = Projectile.new_projectile(bubble,plr.position,vel,damage + plr.get_plr_Atk())
	proj.hostile = false
	await super(plr)
	return true


	
func add_recipes():
	var recipe = Recipe.new()
	recipe.add_ingredient(Emerald, 1)
	recipe.add_ingredient(CopperBar, 3)
	recipe.add_ingredient(Sulfur, 3)
	recipe.add_health_sacrifice(10)
	recipe.set_result(EmeraldWand.new())
	recipe.register()
