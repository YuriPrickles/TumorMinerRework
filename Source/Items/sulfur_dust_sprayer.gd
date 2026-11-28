class_name SulfurDustSprayer
extends Item

func _init(stk:int=1) -> void:
	anim_type = AnimationType.RAISE
	max_stack = 1
	use_delay = 0.1
	auto_use = true
	damage = 1
	super(stk)

var proj:SulfurCloudProj

const cloud = preload("res://Source/Projectiles/sulfur_cloud.tscn")

func use_item(plr:Player) -> bool:
	super(plr)
	proj = Projectile.new_projectile(cloud,plr.position + (plr.aim_to_mouse() * 48),(plr.aim_to_mouse() * 5).rotated(deg_to_rad(randi_range(-35,35))),damage)
	proj.duration = 7
	proj.iframes = 0.12
	proj.lifetime = 0.3
	proj.hostile = false
	proj.gpu_particles_2d.speed_scale = 3
	return true

func add_recipes():
	var recipe = Recipe.new()
	recipe.add_ingredient(CopperBar,3)
	recipe.add_ingredient(IronBar,3)
	recipe.add_ingredient(Sulfur,6)
	recipe.add_ingredient(Rock,9)
	recipe.set_result(SulfurDustSprayer.new())
	recipe.register()
