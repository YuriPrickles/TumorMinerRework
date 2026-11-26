class_name CrockPot
extends Item

func _init(stk:int=1) -> void:
	type = Type.PLACEABLE
	anim_type = AnimationType.INVISIBLE
	use_delay = 0.3
	max_stack = 99
	consumable = true
	super(stk)

var crockpot_scene : PackedScene = preload("res://Source/Interactables/crock_pot_interactable.tscn")
func use_item(plr:Player) -> bool:
	var pos = Main.instance.current_floor.to_local_position(plr.get_targeted_tile())
	for inter:Interactable in Main.instance.current_floor.interactables.get_children():
		if inter.position == pos:
			return false
		if Main.instance.current_floor.current_layout.astar_grid.is_point_solid(Main.instance.current_floor.to_tile_grid(pos)):
			return false
	await super(plr)
	var smelter:CrockPotInteractable = crockpot_scene.instantiate()
	Main.instance.current_floor.place_interactable(smelter,pos)
	return true

func add_recipes():
	var recipe = Recipe.new()
	recipe.add_ingredient(Charcoal, 3)
	recipe.add_ingredient(TerracottaPot, 1)
	recipe.add_ingredient(IronBar, 3)
	recipe.add_ingredient(CopperBar, 3)
	recipe.set_result(CrockPot.new())
	recipe.register()
