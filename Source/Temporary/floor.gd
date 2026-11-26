class_name Floor
extends Node2D

@export var enemies: Node2D
func get_enemies() -> Array[Enemy]:
	return (enemies.get_children() as Array[Enemy])
@export var interactables: Node2D
func get_interactables() -> Array[Interactable]:
	return (interactables.get_children() as Array[Interactable])
@export var pickups: Node2D
@export var projectiles: Node2D
func get_projectiles() -> Array[Projectile]:
	return (projectiles.get_children() as Array[Projectile])
@export var rock_nodes: Node2D
func get_rock_nodes() -> Array[RockNode]:
	return (rock_nodes.get_children() as Array[RockNode])
@export var environment: Node2D

@export var ladder_scene:PackedScene
@export var layout_pool:LayoutPool

var current_layout:Layout
var already_spawned_ladder:bool = false
var ladder_spawn_chance: float = 0.05
var ldr_ch_incr_min: float = 0.02
var ldr_ch_incr_max: float = 0.04
var tile_size: int = 64
func _ready() -> void:
	current_layout = layout_pool.layout_pool.pick_random().instantiate()
	environment.add_child(current_layout)
	tile_size = current_layout.layout_tiles.tile_set.tile_size.x
	queue_redraw()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
	#if Engine.get_frames_drawn() % 30 == 0:
		#queue_redraw()
	pass

func _draw() -> void:
	var plr = Main.instance.get_player()
	var tile_size_vector = Vector2(tile_size,tile_size)
	draw_rect(Rect2(to_local_position(plr.get_targeted_tile()) - tile_size_vector / 2,tile_size_vector),Color.RED,false,4)
	#for i in range(-16,16):
		#for j in range(-16,16):
			#draw_rect(Rect2(i * 64, j * 64, 64, 64), Color.GREEN,false)
	#for tile in current_layout.layout_tiles.get_used_cells():
		#draw_string(ThemeDB.fallback_font,current_layout.layout_tiles.map_to_local(tile),str(tile),HORIZONTAL_ALIGNMENT_CENTER)
		#if current_layout.astar_grid.is_point_solid(tile):
			#draw_circle(current_layout.layout_tiles.map_to_local(tile),8,Color.RED)
		#else:
			#draw_circle(current_layout.layout_tiles.map_to_local(tile),8,Color.GREEN)
	pass

func increase_ladder_chance():
	ladder_spawn_chance += randf_range(ldr_ch_incr_min,ldr_ch_incr_max)

func spawn_ladder(pos: Vector2):
	if already_spawned_ladder: return
	var ladder:Ladder = ladder_scene.instantiate()
	ladder.position = pos
	interactables.add_child(ladder)
	already_spawned_ladder = true

func place_interactable(interactable:Interactable,pos:Vector2):
	current_layout.astar_grid.set_point_solid(to_tile_grid(pos))
	interactable.position = pos + Vector2(0,32)
	interactables.add_child(interactable)

func to_tile_grid(pos:Vector2) -> Vector2i:
	return current_layout.layout_tiles.local_to_map(pos)

func to_local_position(tilepos:Vector2i) -> Vector2:
	return current_layout.layout_tiles.map_to_local(tilepos)
