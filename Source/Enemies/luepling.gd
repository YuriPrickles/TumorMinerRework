class_name Luepling
extends Enemy
@export var detection_range: Area2D
@export var bite_range: Area2D
@export var bite_hitbox: Area2D

var chasing:bool = false
var doing_bite_attack = false
var plr_in_bite_range = false
var bite_cooldown_timer:float = 0
const BITE_COOLDOWN:float = 3
var vomiting:bool = false
var running_away:bool = false
var vomited_egg:bool = false
func _ready() -> void:
	super()
	detection_range.body_entered.connect(
		func(body):
			if body is Player:
				chasing = true
	)
	bite_range.body_entered.connect(
		func(body):
			if body is Player:
				if not doing_bite_attack and bite_cooldown_timer <= 0 and not running_away:
					start_bite()
	)
	enemy_sprite.animate("idle")

var prepare_bite_on_land:bool = false
func start_bite():
	if not landed:
		prepare_bite_on_land = true
		return
	var plr : Player = Main.instance.get_player()
	doing_bite_attack = true
	enemy_sprite.animate("pre_bite")
	await enemy_sprite.animation_player.animation_finished
	for i in 4:
		enemy_sprite.animate("bite")
		bite_hitbox.rotation = deg_to_rad(90) + plr.position.direction_to(position).angle()
		await enemy_sprite.hit
		plr_in_bite_range = bite_hitbox.get_overlapping_bodies().has(plr)
		if plr_in_bite_range:
			plr.hurt(4, position, 0)
		await enemy_sprite.animation_player.animation_finished
	enemy_sprite.animate("idle")
	bite_cooldown_timer = BITE_COOLDOWN
	doing_bite_attack = false

var egg : PackedScene = preload("res://Source/RockNodes/luepus_egg_node.tscn")
func vomit_egg():
	vomiting = true
	vomited_egg = true
	enemy_sprite.force_animate("vomit_egg")
	await enemy_sprite.hit
	var coords = get_current_tile()
	var rock:RockNode = egg.instantiate()
	grid.set_point_solid(coords)
	rock.position = tilemap.map_to_local(coords) + rock.rock_placement_offset
	Main.instance.current_floor.rock_nodes.add_child(rock)
	enemy_sprite.animate("idle")
	running_away = false
	vomiting = false

func _process(delta: float) -> void:
	if bite_cooldown_timer > 0:
		bite_cooldown_timer -= delta
func _physics_process(delta: float) -> void:
	super(delta)
	var plr : Player = Main.instance.get_player()
	if not prepare_bite_on_land and bite_range.get_overlapping_bodies().has(plr) and bite_cooldown_timer <= 0:
		await start_bite()
	enemy_sprite.sprite.flip_h = position.x <= plr.position.x
	if chasing and not doing_bite_attack and not vomiting:
		basic_movement(delta)

var jump_timer: float = 0.0
var landed:bool = true
func basic_movement(delta):
	while move_points.size() <= 1 or move_points[-1] == Vector2.ZERO or (runaway_target_cell and runaway_target_cell == Vector2i.ZERO):
		modulate = Color.BLUE
		if move_points.size() > 1 and move_points[-1] == Vector2.ZERO:
			move_points.remove_at(move_points.size()-1)
		if not running_away:
			update_path()
		else:
			update_path_runaway()
		return
	var destination:Vector2 = move_points[-1]
	modulate = Color.WHITE
	if landed:
		jump_timer += delta
		if jump_timer >= (0.3 if not running_away else 0.1) and landed:
			enemy_sprite.force_animate("jump")
			await enemy_sprite.hit
			landed = false
			set_collision_mask_value(1, false)
			var tween:Tween = create_tween()
			tween.tween_property(self,"position",destination,0.35)
			tween.tween_callback(func():
				enemy_sprite.animate("jump_land")
				await enemy_sprite.hit
				landed = true
				jump_timer = 0
				set_collision_mask_value(1, true)
				if not vomited_egg and get_current_tile().distance_to(runaway_target_cell) < 2:
					vomit_egg()
				if prepare_bite_on_land:
					await start_bite()
					prepare_bite_on_land = false
				if not vomited_egg and (running_away or health < 12):
					running_away = true
					update_path_runaway()
				else:
					update_path()
				)
		return
	
	#var collision = move_and_collide(velocity * delta)
	#if collision and collision.get_collider() is Player:
		#on_collide_player(collision.get_collider())

func update_path():
	var plr : Player = Main.instance.get_player()
	var target = pos_to_cell(plr.global_position)
	current_cell = pos_to_cell(global_position)
	target_cell = target
	move_points = (grid.get_point_path(current_cell,target_cell,true) as Array).map(func(p): return (to_local(p) + grid.cell_size / 2))
	if move_points.size() > 4:
		move_points.resize(4)
	var line_points = (move_points.duplicate())
	line_2d.points = line_points
	move_points = (grid.get_point_path(current_cell,target_cell,true) as Array).map(func(p): return ((p) + grid.cell_size / 2))
	if move_points.size() > 4:
		move_points.resize(4)

var runaway_target_cell : Vector2i = Vector2i(INT64_MIN,INT64_MIN)
func update_path_runaway():
	var plr : Player = Main.instance.get_player()
	while (not runaway_target_cell or
		grid.is_point_solid(runaway_target_cell) or
		runaway_target_cell.distance_to(plr.get_current_tile()) < 3):
		runaway_target_cell = tilemap.get_used_cells().pick_random()

	current_cell = pos_to_cell(global_position)
	if runaway_target_cell != target_cell:
		target_cell = runaway_target_cell
	move_points = (grid.get_point_path(current_cell,target_cell,true) as Array).map(func(p): return (to_local(p) + grid.cell_size / 2))
	move_points.resize(4)
	var line_points = (move_points.duplicate())
	line_2d.points = line_points
	move_points = (grid.get_point_path(current_cell,target_cell,true) as Array).map(func(p): return ((p) + grid.cell_size / 2))
	move_points.resize(4)
	landed = true

func on_hurt_animation():
	if not running_away or vomiting:
		super()
