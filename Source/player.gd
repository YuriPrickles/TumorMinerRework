class_name Player
extends CharacterBody2D
@export var interact_range: Area2D
@export var held_item: HeldItem
@export var hand_spot: Marker2D
@export var player_sprite: Sprite2D

const SPEED = 300.0
var   ACCEL = 1.0 #Multiplier used to adjust player speed with debuffs/buffs
var rocks:Array[RockNode]
var interactables:Array[Interactable]
var pickups:Array[Pickup]
#Defense and attack stat, both additive
#Basic Stats applied to any and all effects from the player itself
#AFFECTS BY PARTS ONLY
var atk : int
var def : int

#Stat modifiers that are used to apply buffs, 
#can be positive OR negative depending on result of all active buffs
#AFFECTED BY STATUSES ONLY
var atkMod : float
var defMod : float
var firstLoad : bool = true

#var plrEffects = {}
var plr_statuses:Array[StatusEffect]

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

@onready var limb_visual:PackedScene = preload("res://Source/Visuals/modular_limb.tscn")

@export_subgroup("Arms")
@export var ArmLeft:Node
@export var AdditionalArmsLeft:Node
@export var ArmRight:Node
@export var AdditionalArmsRight:Node
## Default Arm Length While Aiming
@export var arm_length:float = 70
## Default Arm Length When Using an Item
@export var arm_length_interact:float = 100
@onready var active_arm_length:float = arm_length

@export_subgroup("Legs")
@export var LegLeft:Node
@export var AdditionalLegsLeft:Node
@export var StepMarkerLeft:Node
@export var LegRight:Node
@export var AdditionalLegsRight:Node
@export var StepMarkerRight:Node


func _ready() -> void:
	interact_range.body_entered.connect(detect_thing)
	interact_range.body_exited.connect(undetect_thing)
	interact_range.area_entered.connect(detect_thing)
	interact_range.area_exited.connect(undetect_thing)
	if (firstLoad) : prepare_stats()
	retrieve_effects() #Re-applies effects accrued on a previous floor IF APPLICABLE

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
				use_arm()
		elif Input.is_action_just_pressed("use"):
			if not held_item.animating:
				use_item_method.call()
				use_arm()
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
	var addt_arms = [AdditionalArmsLeft, AdditionalArmsRight]
	var aim_direction = int(aim_to_mouse().x >= 0)
	for i in arms.size():
		var arm = arms[i]
		var addt = addt_arms[i]
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
		
		for child in addt.get_children():
			var angle = PI / (arm.get_child_count() - child.get_index() + 1)
			angle *= sign(side * 2 - 1)
			child.apex_destination = arm.apex_destination.rotated(angle)
	
	#Legs
	var legs = [LegLeft, LegRight]
	var addt_legs = [AdditionalLegsLeft, AdditionalLegsRight]
	var steps = [StepMarkerLeft, StepMarkerRight]
	for i in 2:
		var dest = legs[i].get_local_destination(steps[i].global_position)
		legs[i].apex_destination = dest
		
		var addt = addt_legs[i]
		for child in addt.get_children():
			var angle = PI / (addt.get_child_count() - child.get_index() + 1)
			angle *= sign(i * 2 - 1)
			child.apex_destination = legs[i].apex_destination.rotated(angle)
	
	if stagger_timer > 0:
		stagger_timer -= delta
	#else:
		#knockback_velocity = Vector2.ZERO
	
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

var tickDuration : float
func _process(delta: float) -> void:
	tickDuration += delta
	if (fmod(tickDuration, 100) > 1) :
		tickDuration = 0
		#print("tick")
		for eff in plr_statuses:
			eff.process_effect(self, delta)

## leftovers of a bygone system... maybe it will find its use someday
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

## leftovers of a bygone system... maybe it will find its use someday
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
		if get_targeted_tile() == interactable.get_current_tile() or get_current_tile() == interactable.get_current_tile():
			return interactable
	return null

func _input(event: InputEvent) -> void:
	#region Inventory Control
	if event.is_action_pressed("drop_item") and Global.get_current_item():
		var pickup = Pickup.new_pickup(Global.get_current_item(),position)
		pickup.delay_before_sentience = 3
		Global.inv_manager.inventory[Global.current_item_index] = null
		
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


func hurt(elm:ElementalType, source_position:Vector2, kb_force = 500):
	if stagger: return
	stagger_timer = stagger_delay
	#Test using player position for separting status vs. enemy damage
	#Revamp atk/def stat for player and enemies
	knockback_velocity = position.direction_to(source_position) * -kb_force
	#print(knockback_velocity)
	knockless_hurt(elm)

func knockless_hurt(elm:ElementalType):
	Global.run_info.health -= (elm.damage - (self.get_plr_Def()))
	Global.popup_text(str(elm.damage),position,elm.color)

func heal(value):
	Global.run_info.health += value

#Call this function from your enemy to give the player a status!
func suffer_effect(effect:StatusEffect) -> void :
	#print(effect)
	StatusEffect.add_effect(plr_statuses, effect)
	#print(plr_statuses.active_effects.has(effect))
	#print(plr_statuses.active_effects.get(effects.burned))

func save_effects() -> void:
	Global.save_plr_effects(self)

func retrieve_effects() -> void:
	plr_statuses = Global.load_plr_effects()

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

func load_limb_visuals(limbs:Array):
	var limb_visuals = [AdditionalArmsRight, AdditionalArmsRight]
	# Clear limbs
	for visual in limb_visuals:
		for child in visual.get_children():
			child.queue_free()
	
	var iter_arms = 0
	var iter_legs = 0
	for i in limbs.size():
		var limb_instance = limb_visual.instantiate()
		
		var arms = [ArmLeft, ArmRight]
		var legs = [LegLeft, LegRight]
		var addt_arms = [AdditionalArmsLeft, AdditionalArmsRight]
		var addt_legs = [AdditionalLegsLeft, AdditionalLegsRight]
		
		var limbs_array = null
		var addt = null
		
		var side = 0
		match limbs[i].part_type:
			"arm":
				limbs_array = arms
				addt = addt_arms
				
				side = iter_arms % 2
				
				if iter_arms == 0:
					ArmLeft.source_limb = limbs[i]
					iter_arms += 1
					continue
				elif iter_arms == 1:
					ArmRight.source_limb = limbs[i]
					iter_arms += 1
					continue
				
				iter_arms += 1
			"leg":
				limbs_array = legs
				addt = addt_legs
				
				side = iter_legs % 2
				
				if iter_legs == 0:
					LegLeft.source_limb = limbs[i]
					iter_legs += 1
					continue
				elif iter_legs == 1:
					LegRight.source_limb = limbs[i]
					iter_legs += 1
					continue
				
				iter_legs += 1
		
		var parent = addt[side]
		var limb = limbs_array[side]
		
		parent.add_child(limb_instance)
		limb_instance.Origin = limb.Origin
		limb_instance.modulate.v = max(0, 1 - int( (i + 1) / 2) * 0.1)
