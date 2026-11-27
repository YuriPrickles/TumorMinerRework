class_name DynamiteDecent
extends Item

func _init(stk:int=1) -> void:
	max_stack = 20
	type = Type.WEAPON
	anim_type = AnimationType.PICKAXE
	use_delay = 0.3
	damage = 25
	consumable = true
	super(stk)

const bomb = preload("res://Source/Projectiles/generic_bomb.tscn")
func use_item(plr:Player) -> bool:
	var flr : Floor = Main.instance.current_floor
	var vel: Vector2 = Vector2.ZERO
	var proj:GenericBomb = Projectile.new_projectile(bomb,flr.to_local_position(plr.get_current_tile()),vel,damage)
	proj.boom_radius = 4
	proj.boom_strength = 8
	proj.fuse_duration = 3
	proj.texture.texture = texture
	await super(plr)
	return true

func shift_use_item(plr:Player) -> bool:
	var flr : Floor = Main.instance.current_floor
	var vel: Vector2 = plr.aim_to_mouse() * 8
	var proj:GenericBomb = Projectile.new_projectile(bomb,flr.to_local_position(plr.get_current_tile()),vel,damage)
	proj.boom_radius = 4
	proj.boom_strength = 8
	proj.fuse_duration = 3
	proj.texture.texture = texture
	await super(plr)
	return true
	
func add_recipes():
	var recipe = Recipe.new()
	recipe.add_ingredient(Gunpowder, 3)
	recipe.add_ingredient(IronOre, 4)
	recipe.set_result(DynamiteDecent.new(4))
	recipe.register()
