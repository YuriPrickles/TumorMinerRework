class_name Enemy
extends CharacterBody2D
@export var enemy_sprite:EnemySprite
@export var line_2d: Line2D
@export var health: int
@export var kb_res:float = 0
@export var movement_speed: float = 150.0
@export var acceleration: float = 256
var grid:AStarGrid2D
var tilemap:TileMapLayer
var move_points:PackedVector2Array
var current_point:int
var current_cell:Vector2i
var target_cell:Vector2i

func _ready() -> void:
	var lambda = func():
		await get_tree().physics_frame
		tilemap = Main.instance.current_floor.current_layout.layout_tiles
		grid = Main.instance.current_floor.current_layout.astar_grid
		current_cell = pos_to_cell(global_position)
		target_cell = current_cell
	lambda.call_deferred()

func _physics_process(delta: float) -> void:
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

func destroy():
	on_destroy()
	queue_free()

func on_destroy():
	pass
	
func hurt(damage:int, source):
	on_hurt(damage,source)
	health -= damage
	if health <= 0:
		destroy()

func on_hurt(damage:int, source):
	on_hurt_animation()
	if source and kb_res < 1:
		flinch(source)

func on_hurt_animation():
	if enemy_sprite.animation_player.has_animation("hurt"):
		enemy_sprite.animate("hurt")

func on_collide_player(plr:Player):
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
