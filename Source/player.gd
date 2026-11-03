class_name Player
extends CharacterBody2D
@export var interact_range: Area2D
@export var held_item: HeldItem
@export var hand_spot: Marker2D
@export var player_sprite: Sprite2D

const SPEED = 400.0
var rocks:Array[RockNode]
var interactables:Array[Interactable]
var pickups:Array[Pickup]

var stagger: bool:
	get:
		return stagger_timer > 0
var stagger_timer: float = 0
var stagger_delay: float = 0.2
var knockback_velocity: Vector2

var speed_mult = 1

func _ready() -> void:
	interact_range.body_entered.connect(detect_thing)
	interact_range.body_exited.connect(undetect_thing)
	interact_range.area_entered.connect(detect_thing)
	interact_range.area_exited.connect(undetect_thing)

func _physics_process(delta: float) -> void:
	if not held_item.animating:
		player_sprite.flip_h = aim_to_mouse().x < 0
		hand_spot.position.x = 31 * (-1 if aim_to_mouse().x < 0 else 1)
		hand_spot.scale.x = (-1 if aim_to_mouse().x < 0 else 1)
	
	if stagger_timer > 0:
		stagger_timer -= delta
	
	var direction := Input.get_vector("left", "right","up","down")
	if not stagger:
		if direction:
			velocity = direction * SPEED * speed_mult
		else:
			velocity = velocity.move_toward(Vector2.ZERO, SPEED / 3)
	else:
		velocity = knockback_velocity
	move_and_slide()

func detect_thing(body:Node2D):
	if body is RockNode:
		body.on_detect()
		rocks.append(body)
	if body is Interactable:
		body.on_detect()
		interactables.append(body)
	if body is Pickup:
		body.on_detect()
		pickups.append(body)


func undetect_thing(body:Node2D):
	if body is RockNode and rocks.has(body):
		body.on_undetect()
		rocks.erase(body)
	if body is Interactable and interactables.has(body):
		body.on_undetect()
		interactables.erase(body)
	if body is Pickup and pickups.has(body):
		body.on_undetect()
		pickups.erase(body)

func _input(event: InputEvent) -> void:
	if not held_item.animating:
		if event.is_action_pressed("use") and Global.get_current_item() and Global.get_current_item().can_use_item():
			Global.get_current_item().use_item(self)
		if event.is_action_pressed("interact"):
			for thing in interactables:
				if thing.in_range and thing.hovered:
					thing.interact(self)
		#region Inventory Control
		var old_item = Global.get_current_item()
		Global.current_item_index += roundi(Input.get_axis("inv_back","inv_forward"))
		if Global.current_item_index < 0:
			Global.current_item_index = 8
		if Global.current_item_index > 8:
			Global.current_item_index = 0
		if old_item != Global.get_current_item():
			if old_item:
				old_item.on_switch_away(self)
			if Global.get_current_item():
				Global.get_current_item().on_switch_to(self)
		#endregion

func request_mine_action(rock, strength):
	if Global.get_current_item().type == Item.Type.PICKAXE:
		rock.on_mine(strength, self)

func aim_to_mouse() -> Vector2:
	return position.direction_to(get_global_mouse_position())

func hurt(damage, source_position):
	if stagger: return
	stagger_timer = stagger_delay
	Global.run_info.health -= damage
	knockback_velocity = position.direction_to(source_position) * -500
	print(knockback_velocity)

func heal(value):
	Global.run_info.health += value
