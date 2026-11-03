class_name MiniSmelterInteractable
extends Interactable
@export var animation_player: AnimationPlayer
@export var texture_rect: TextureRect
@export var progress_bar: ProgressBar

var current_recipe:Recipe = null
var inventory:Array[Item]
func _ready() -> void:
	super()
	animation_player.play("sleep")

func on_mine(value, plr:Player):
	queue_free()
	Pickup.new_pickup(MiniSmelter.new(),position)
	Main.instance.current_floor.current_layout.astar_grid.set_point_solid(Main.instance.current_floor.to_tile_grid(position))
	for item in inventory:
		Pickup.new_pickup(item,position)

var smelt_timer: float = 0
var SMELT_TIMER_MAX: float = 5.0
func _process(delta: float) -> void:
	progress_bar.value = (smelt_timer / SMELT_TIMER_MAX) * 100
	if current_recipe and inventory.size() > 0:
		texture_rect.texture = current_recipe.result_item.texture
		smelt_timer += delta
		if smelt_timer >= SMELT_TIMER_MAX:
			inventory.pop_front()
			Pickup.new_pickup(current_recipe.result_item.duplicate(),position)
			smelt_timer = 0
			if inventory.is_empty():
				current_recipe = null
				animation_player.play("sleep")
	else:
		texture_rect.texture = null
		smelt_timer = 0.0

func interact(plr:Player):
	var held_item = Global.get_current_item()
	if not held_item: return
	if current_recipe:
		var stack_need = current_recipe.ingredient_list.values()[0]
		var item_need = current_recipe.ingredient_list.keys()[0]
		if held_item.stack < stack_need or held_item.get_item_class_name() != item_need.get_global_name(): return
		inventory.append(held_item.get_script().new(stack_need))
		Global.inv_manager.consume_item(held_item.get_script(), stack_need)
	else:
		for smr in Recipe.smelt_recipes:
			var ing_name = smr.ingredient_list.keys()[0].get_global_name()
			var ing_stack = smr.ingredient_list.values()[0]
			if ing_name == held_item.get_item_class_name() and ing_stack <= held_item.stack:
				animation_player.play("awake")
				inventory.append(held_item.get_script().new(ing_stack))
				current_recipe = smr
				Global.inv_manager.consume_item(held_item.get_script(), ing_stack)
