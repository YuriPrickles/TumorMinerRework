class_name Player
extends CharacterBody2D
@export var interact_range: Area2D
@export var held_item: HeldItem
@export var hand_spot: Marker2D
@export var player_sprite: Sprite2D

const SPEED = 300.0
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

##For the purposes of using player position in local_to_map functions.
var small_position_offset: Vector2 = Vector2(0,1)
var snapped_facing_dir:Vector2

#LIMBS
@export_group("Limbs")

@export_subgroup("Arms")
@export var ArmLeft:Node
@export var ArmRight:Node
## Default Arm Length While Aiming
@export var arm_length:float = 70
## Default Arm Length When Using an Item
@export var arm_length_interact:float = 100
@onready var active_arm_length:float = arm_length

@export_subgroup("Legs")
@export var LegLeft:Node
@export var StepMarkerLeft:Node
@export var LegRight:Node
@export var StepMarkerRight:Node


func _ready() -> void:
	interact_range.body_entered.connect(detect_thing)
	interact_range.body_exited.connect(undetect_thing)
	interact_range.area_entered.connect(detect_thing)
	interact_range.area_exited.connect(undetect_thing)

func _physics_process(delta: float) -> void:
	var mouse_vector:Vector2 = position.direction_to(get_global_mouse_position()).normalized()
	snapped_facing_dir = mouse_vector.snapped(Vector2.ONE)
	#print(snapped_facing_dir)
	var current_item = Global.get_current_item()
	if current_item and current_item.can_use_item():
		var use_item_method : Callable = Global.get_current_item().use_item.bind(self) if not current_item.can_use_shift() and not Input.is_action_pressed("use_modifier") else Global.get_current_item().shift_use_item.bind(self)
		if current_item.auto_use and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if not held_item.animating:
				use_item_method.call()
		elif Input.is_action_pressed("use"):
			if not held_item.animating:
				use_item_method.call()
	if Input.is_action_just_pressed("interact"):
		if get_targeted_interactable():
			get_targeted_interactable().interact(self)
	if not held_item.animating:
		#player_sprite.flip_h = aim_to_mouse().x < 0
		"""
		Note: Hi it's Adam!
		I'm commenting out the above code because
		I would like to replace the sprite flipping
		with just switching hands.
		Let me know what you think!
		It would also be better for when adding
		visuals of equipped body parts,
		so that they aren't constantly swapping.
		"""
		#hand_spot.position.x = 31 * (-1 if aim_to_mouse().x < 0 else 1)
		hand_spot.scale.x = (-1 if aim_to_mouse().x < 0 else 1)
	
	#Limb Logic
	
	#Arms
	var arms = [ArmLeft, ArmRight]
	var aim_direction = int(aim_to_mouse().x >= 0)
	for arm in arms:
		var side = arms.find(arm)
		if side == aim_direction:
			arm.apex_destination = aim_to_mouse() * active_arm_length
			hand_spot.global_position = arm.ApexDisplay.global_position
		else:
			arm.apex_destination = Vector2(
				# X * 2 - 1 converts <0,1> to <-1,1>
				40 * (side * 2 - 1),
				50
			)
	
	#Legs
	var legs = [LegLeft, LegRight]
	var steps = [StepMarkerLeft, StepMarkerRight]
	for i in 2:
		var dest = legs[i].get_local_destination(steps[i].global_position)
		legs[i].apex_destination = dest
	
	if stagger_timer > 0:
		stagger_timer -= delta
	
	var direction := Input.get_vector("left", "right","up","down")
	if not stagger:
		rotation += (-PI / 12 * sign(direction.x) - rotation) * delta * 5
		rotation = clamp(rotation, -PI / 12, PI / 12)
		if direction:
			velocity = direction * SPEED * speed_mult
			$PlayerAnim.play("walk")
		else:
			velocity = velocity.move_toward(Vector2.ZERO, SPEED / 3)
			$PlayerAnim.play("idle")
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

func get_targeted_interactable() -> Interactable:
	var c_floor :Floor = Main.instance.current_floor
	var tiles :TileMapLayer = c_floor.current_layout.layout_tiles
	for interactable in c_floor.get_interactables():
		var interactable_tilepos : Vector2i = tiles.local_to_map(interactable.position - interactable.placement_offset)
		if get_targeted_tile() == interactable_tilepos or get_current_tile() == interactable_tilepos:
			return interactable
	return null

func _input(event: InputEvent) -> void:
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

##Returns a Vector2i position on the tilemap. Use map_to_local to actually do things with it.
func get_current_tile() -> Vector2i:
	var c_floor :Floor = Main.instance.current_floor
	var tiles :TileMapLayer = c_floor.current_layout.layout_tiles
	var current_tile := tiles.local_to_map(position - small_position_offset)
	return current_tile

##Returns a Vector2i position on the tilemap. Use map_to_local to actually do things with it.
func get_targeted_tile() -> Vector2i:
	var target_tile = get_current_tile() + Vector2i(snapped_facing_dir)
	return target_tile

#Let me know if you want me to move this somewhere else in the script
## Pulse the arm for juicy effect
func use_arm(time:float = 0.1):
	active_arm_length = arm_length_interact
	await get_tree().create_timer(time).timeout
	active_arm_length = arm_length
