class_name Enemy
extends CharacterBody2D
@export var enemy_sprite:EnemySprite

@export var line_2d: Line2D
@export var health: int
@export var max_health: int = -1
@export var kb_res:float = 0
@export var movement_speed: float = 150.0
@export var acceleration: float = 256
##Enemy will have an outline when in range of a pickaxe.
@export var allow_mining: bool = false
@export_flags("Neutral", "Fire", "Sulfur", "Bug", "Flying",) var tribes: int

var grid:AStarGrid2D
var tilemap:TileMapLayer
var move_points:PackedVector2Array
var current_point:int
var current_cell:Vector2i
var target_cell:Vector2i

var enemy_statuses : Array[StatusEffect]
#Add atk, add def, understand how to affect health using status effects
#Def modifier is additive

func _ready() -> void:
	if max_health < 0: max_health = health
	var lambda = func():
		await get_tree().physics_frame
		tilemap = Main.instance.current_floor.current_layout.layout_tiles
		grid = Main.instance.current_floor.current_layout.astar_grid
		current_cell = pos_to_cell(global_position)
		target_cell = current_cell
	lambda.call_deferred()

func _physics_process(delta: float) -> void: pass
func _process(delta: float) -> void:
	for eff in enemy_statuses:
		eff.process_enemy_effect(self, delta)
	pass

func basic_movement(delta):
	var plr : Player = Main.instance.get_player()
	var destination:Vector2
	var dir:Vector2
	if move_points.size() > 1:
		destination = ((move_points[1]))
		dir = position.direction_to(destination)
	else:
		dir = position.direction_to(plr.position)
	velocity = velocity.move_toward(dir * movement_speed,delta * acceleration)
	var collision = move_and_collide(velocity * delta)
	if collision and collision.get_collider() is Player:
		on_collide_player(collision.get_collider())
	if collision and collision.get_collider() is RockNode:
		on_collide_rock(collision.get_collider())
	if collision and collision.get_collider() is TileMapLayer:
		on_collide_wall()
	update_path()

func update_path():
	var plr : Player = Main.instance.get_player()
	var target = pos_to_cell(plr.global_position)
	current_cell = pos_to_cell(global_position)
	target_cell = target
	move_points = (grid.get_point_path(current_cell,target_cell,true) as Array).map(func(p): return (to_local(p) + grid.cell_size / 2))
	var line_points = (move_points.duplicate())
	line_2d.points = line_points
	move_points = (grid.get_point_path(current_cell,target_cell,true) as Array).map(func(p): return ((p) + grid.cell_size / 2))


func pos_to_cell(pos:Vector2) -> Vector2i:
	return tilemap.local_to_map(pos)

##Override for any pre-death shenanigans.
func destroy():
	on_destroy()
	queue_free()

##Override for things like death particles and loot.
func on_destroy():
	pass
	
func hurt(elm:ElementalType, source=null):
	if health <= 0:
		return
	enemy_sprite.hit_flash_player.play("hit_flash")
	on_hurt(elm.damage,source)
	knockless_hurt(elm)

func knockless_hurt(elm:ElementalType):
	health -= max(0,elm.damage)
	if elm.damage >= 0:
		Global.popup_text(str(elm.damage),position,elm.color)
	if health <= 0:
		destroy()

func on_hurt(damage:int, source):
	Global.trigger_combat_state()
	if source: on_hurt_animation()
	if source and kb_res < 1:
		flinch(source)

## Override this function to make sure the hurt animation does not override your enemy's animations.
func on_hurt_animation():
	if enemy_sprite.animation_player.has_animation("hurt"):
		enemy_sprite.animate("hurt")

func heal(heal_amount:int):
	health = min(max_health, health + heal_amount)
	Global.popup_text(str("+",heal_amount),position,Color.LIME)
	return

func on_collide_player(plr:Player):
	pass
func on_collide_rock(rck:RockNode):
	pass
func on_collide_wall():
	pass

func flinch(source):
	var extra_kb:float = 0
	if source is Projectile:
		extra_kb = source.knockback
	velocity = source.position.direction_to(position) * ((extra_kb + 100) * (1 - kb_res))

##Returns a Vector2i position on the tilemap. Use map_to_local to actually do things with it.
func get_current_tile() -> Vector2i:
	var c_floor :Floor = Main.instance.current_floor
	var tiles :TileMapLayer = c_floor.current_layout.layout_tiles
	var current_tile := tiles.local_to_map(position)
	return current_tile

func suffer_effect(effect:StatusEffect) -> void :
	#print(effect)
	StatusEffect.add_effect(enemy_statuses, effect)
	#print(plr_statuses.active_effects.has(effect))
	#print(plr_statuses.active_effects.get(effects.burned))

func react_to_element(type:ElementalType,is_status=false):
	pass

## Override to add additional conditions for being mineable.[br]
## Takes in the player's targeted tile as a parameter.[br]
## Has no conditions by default other than allow_mining.
func is_mineable(target_tile:Vector2i):
	if allow_mining:
		return true
	return false

## Override to do something when this is mined.
func on_mine(strength:int):
	pass
