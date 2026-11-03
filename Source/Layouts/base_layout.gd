class_name Layout
extends Node2D
@export var layout_tiles: TileMapLayer
@export var event_tiles: TileMapLayer
@export var top_left: Marker2D
@export var bottom_right: Marker2D
@export var rock_spawn:RockSpawn
@export var enemy_spawn:EnemySpawn
const TILE_SIZE = 64
const WALL = Vector2i(0,0)
const ROCK_SPAWN = Vector2i(1,0)
const ENEMY_SPAWN = Vector2i(1,1)
const PLAYER_SPAWN = Vector2i(1,2)

var rng = RandomNumberGenerator.new()
var astar_grid:AStarGrid2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	astar_setup()
	spawn_things()

func astar_setup() -> void:
	astar_grid = AStarGrid2D.new()
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER

	astar_grid.cell_size = layout_tiles.tile_set.tile_size
	astar_grid.region = Rect2(top_left.position,bottom_right.position - top_left.position)
	astar_grid.update()

func spawn_things():
	for tile in event_tiles.get_used_cells():
		
		match get_event_tile(tile):
			ENEMY_SPAWN:
				spawn_enemy(tile)
			ROCK_SPAWN:
				spawn_rocks(tile)
			PLAYER_SPAWN:
				spawn_player(tile)
	for tile in layout_tiles.get_used_cells():
		if is_wall(tile):
			astar_grid.set_point_solid(tile)
	event_tiles.hide()

func spawn_player(coords:Vector2i):
	var plr:Player = preload("res://Source/player.tscn").instantiate()
	plr.position = layout_tiles.map_to_local(coords)
	Main.instance.current_floor.add_child(plr)

func spawn_rocks(coords:Vector2i):
	if randf_range(0,1) < rock_spawn.rock_spawn_chance:
		var chosen_rock_weight = rock_spawn.rock_weights[rng.rand_weighted(rock_spawn.get_weights())]
		var rock:RockNode = chosen_rock_weight.rock_type.instantiate()
		astar_grid.set_point_solid(coords)
		rock.position = layout_tiles.map_to_local(coords) + rock.rock_placement_offset
		Main.instance.current_floor.rock_nodes.add_child(rock)

func spawn_enemy(coords:Vector2i):
	if randf_range(0,1) < enemy_spawn.enemy_spawn_chance:
		var chosen_enemy_weight = enemy_spawn.enemy_weights[rng.rand_weighted(enemy_spawn.get_weights())]
		var enemy:Enemy = chosen_enemy_weight.enemy_type.duplicate().instantiate()
		enemy.position = layout_tiles.map_to_local(coords)
		Main.instance.current_floor.enemies.add_child(enemy)

func is_wall(coords:Vector2i) -> bool:
	return layout_tiles.get_cell_atlas_coords(coords) == WALL
func check_event_tile(coords:Vector2i, type:Vector2i) -> bool:
	return event_tiles.get_cell_atlas_coords(coords) == type
func get_event_tile(coords:Vector2i) -> Vector2i:
	return event_tiles.get_cell_atlas_coords(coords)
