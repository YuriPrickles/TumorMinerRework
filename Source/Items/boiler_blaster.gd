class_name BoilerBlaster
extends Item

func _init(stk:int=1) -> void:
	max_stack = 20
	type = Type.WEAPON
	anim_type = AnimationType.PICKAXE
	use_delay = 0.8
	damage = 26
	auto_use = true
	super(stk)

const beam = preload("res://Source/Projectiles/boiling_blast_projectile.tscn")
func use_item(plr:Player) -> bool:
	super(plr)
	var flr : Floor = Main.instance.current_floor
	var vel: Vector2 = plr.aim_to_mouse()
	var proj : Projectile = Projectile.new_projectile(beam,plr.position,vel,damage + plr.get_plr_Atk())
	proj.hostile = false
	return true


	
func add_recipes():
	var recipe = Recipe.new()
	recipe.add_ingredient(Charcoal, 4)
	recipe.add_ingredient(CopperBar, 4)
	recipe.add_ingredient(WaterPot, 2)
	recipe.set_result(BoilerBlaster.new())
	recipe.register()
