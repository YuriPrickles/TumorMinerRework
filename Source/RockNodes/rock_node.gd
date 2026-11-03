class_name RockNode
extends StaticBody2D

const rock_placement_offset = Vector2(0,32)
@export var animation_player: AnimationPlayer
@export var navigation_obstacle: NavigationObstacle2D

@export var click_area: Area2D
@export var health:int = 2
var in_range:bool = false
var hovered:bool = false

var real_position:Vector2:
	get:
		return position - rock_placement_offset

func _ready() -> void:
	click_area.mouse_entered.connect(func():hovered=true)
	click_area.mouse_exited.connect(func():hovered=false)

func _process(delta: float) -> void:
	pass

func on_mine(value, plr:Player):
	animation_player.play("hit")
	health -= value
	if health <= 0:
		break_rock()

func break_rock():
	on_break()
	Main.instance.current_floor.current_layout.astar_grid.set_point_solid(
		Main.instance.current_floor.current_layout.layout_tiles.local_to_map(position), false
	)
	queue_free()
	
func on_break():
	if randf_range(0,1) < 0.05:
		Main.instance.current_floor.spawn_ladder(position)
	drop_loot()

func drop_loot():
	Pickup.new_pickup(Rock.new(randi_range(0,3)),position)

func on_detect():
	in_range = true
func on_undetect():
	in_range = false
