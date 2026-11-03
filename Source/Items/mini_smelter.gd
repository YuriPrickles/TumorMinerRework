class_name MiniSmelter
extends Item

func _init(stk:int=1) -> void:
	type = Type.PLACEABLE
	anim_type = AnimationType.INVISIBLE
	use_delay = 0.4
	max_stack = 99
	consumable = true
	super(stk)

var smelter_scene : PackedScene = preload("res://Source/Interactables/mini_smelter_interactable.tscn")
func use_item(plr:Player) -> bool:
	var pos = Main.instance.current_floor.get_local_mouse_position()
	pos = Main.instance.current_floor.current_layout.layout_tiles.local_to_map(pos)
	pos = Main.instance.current_floor.current_layout.layout_tiles.map_to_local(pos)
	for inter:Interactable in Main.instance.current_floor.interactables.get_children():
		if inter.position == pos:
			await plr.held_item.animation_hit
			return false
		if Main.instance.current_floor.current_layout.astar_grid.is_point_solid(Main.instance.current_floor.to_tile_grid(pos)):
			await plr.held_item.animation_hit
			return false
	super(plr)
	var smelter = smelter_scene.instantiate()
	Main.instance.current_floor.place_interactable(smelter,pos)
	await plr.held_item.animation_hit
	return true

func add_recipes():
	var recipe = Recipe.new()
	recipe.add_ingredient(Rock, 12)
	recipe.add_ingredient(CopperOre, 12)
	recipe.add_health_sacrifice(10)
	recipe.set_result(MiniSmelter.new())
	recipe.register()
