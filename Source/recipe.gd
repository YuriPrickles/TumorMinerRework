class_name Recipe
extends Object

static var recipes:Array[Recipe]
static var smelt_recipes:Array[Recipe]

@export var result_item: Item

@export var ingredient_list:Dictionary[Script,int]
var health_requirement:int = 0
var smelt_time:float = 5.0
var needs_water:bool = false

func add_ingredient(item:Script, stack:int):
	ingredient_list[item] = stack

func add_health_sacrifice(health:int):
	health_requirement = health

func add_needs_water(value:bool):
	needs_water = value

func set_result(item:Item):
	result_item = item

func check_craftable() -> bool:
	var plr : Player = Main.instance.get_player()
	var layout : Layout = Main.instance.current_floor.current_layout
	for ingredient:Script in ingredient_list.keys():
		if Global.inv_manager.get_item_count(
			ingredient) < ingredient_list.get(ingredient):
			return false
	if health_requirement > 0 and Global.run_info.health <= health_requirement:
		return false
	if needs_water and not layout.check_layout_tile(plr.get_current_tile(),layout.WATER_TILE):
		return false
	return true

func craft_item() -> bool:
	if not check_craftable(): return false
	for ingredient:Script in ingredient_list.keys():
		Global.inv_manager.consume_item(ingredient, ingredient_list.get(ingredient))
	var result = result_item.duplicate()
	result.stack = result_item.stack
	var pickup = Pickup.new_pickup(result,Main.instance.get_player().position)
	Global.inv_manager.attempt_acquire(pickup, pickup.item_stored)
	Global.run_info.health -= health_requirement
	return true
func register():
	recipes.append(self)

func register_smelt(sm_time:float=5):
	var smelt_single_ingredient_check = ingredient_list.keys().size() == 1
	assert(smelt_single_ingredient_check, "SMELT type recipes can only use 1 ingredient!")
	smelt_time = sm_time
	smelt_recipes.append(self)
