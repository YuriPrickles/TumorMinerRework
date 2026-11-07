class_name Recipe
extends Object

static var recipes:Array[Recipe]
static var smelt_recipes:Array[Recipe]

@export var result_item: Item

@export var ingredient_list:Dictionary[Script,int]
var health_requirement:int = 0

func add_ingredient(item:Script, stack:int):
	ingredient_list[item] = stack

func add_health_sacrifice(health:int):
	health_requirement = health

func set_result(item:Item):
	result_item = item

func check_craftable() -> bool:
	for ingredient:Script in ingredient_list.keys():
		if Global.inv_manager.get_item_count(
			ingredient) < ingredient_list.get(ingredient):
			return false
	if health_requirement > 0 and Global.run_info.health <= health_requirement:
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

func register_smelt():
	var smelt_single_ingredient_check = ingredient_list.keys().size() == 1
	assert(smelt_single_ingredient_check, "SMELT type recipes can only use 1 ingredient!")
	
	smelt_recipes.append(self)
