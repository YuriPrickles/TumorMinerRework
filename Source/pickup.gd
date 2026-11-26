class_name Pickup
extends Area2D

@export var sprite: Sprite2D
var item_stored:Item
var check_for_chasing : bool = false
var chasing : bool = false
static func new_pickup(item:Item, pos:Vector2) -> Pickup:
	if item.stack <= 0:
		return null
	var pickup:Pickup = preload("res://Source/pickup.tscn").instantiate()
	pickup.item_stored = item
	pickup.position = pos
	Main.instance.current_floor.pickups.add_child(pickup)
	return pickup
func _ready() -> void:
	sprite.texture = item_stored.texture
	body_entered.connect(on_body_entered)

func on_body_entered(body:Node2D):
	if body is Player:
		Global.inv_manager.attempt_acquire(self,item_stored)

func on_detect(): check_for_chasing = true
func on_undetect(): check_for_chasing = true
func _process(_delta: float) -> void:
	if check_for_chasing:
		chasing = Global.inv_manager.check_can_acquire(item_stored)
	if chasing:
		position += 5 * position.direction_to(Main.instance.get_player().position)
