class_name CrockPotInteractable
extends Interactable
@export var animation_player: AnimationPlayer
@export var texture_rect: TextureRect
@export var progress_bar: ProgressBar

var inventory:Array[Item]
func _ready() -> void:
	super()
	animation_player.play("RESET")

func on_mine(value, plr:Player):
	queue_free()
	Pickup.new_pickup(CrockPot.new(),position)
	Main.instance.current_floor.current_layout.astar_grid.set_point_solid(Main.instance.current_floor.to_tile_grid(position))
	for item in inventory:
		Pickup.new_pickup(item,position)

var cook_timer: float = 0
var current_cook_time:float = 15

func _process(delta: float) -> void:
	var held_item = Global.get_current_item()
	var plr : Player = Main.instance.get_player()
	if plr.get_targeted_interactable() == self and held_item is Part:
		set_outline(true)
	else:
		set_outline(false)
	progress_bar.value = (cook_timer / current_cook_time) * 100
	if inventory.size() > 1:
		#texture_rect.texture = current_recipe.result_item.texture
		cook_timer += delta
		if cook_timer >= current_cook_time:
			inventory.clear()
			Pickup.new_pickup(WeirdDish.new(),position)
			cook_timer = 0
	else:
		texture_rect.texture = null
		cook_timer = 0.0

func interact(plr:Player):
	var held_item = Global.get_current_item()
	if not held_item or inventory.size() > 1: return
	if held_item is Part:
		inventory.append(held_item.get_script().new())
		Global.inv_manager.consume_item(held_item.get_script(),1)
