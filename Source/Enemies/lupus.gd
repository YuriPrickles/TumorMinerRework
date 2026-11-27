class_name Lupus
extends Enemy

@export var armor:int:
	set(value):
		if value < 0:
			value = 0
		if value > max_armor:
			value = max_armor
		armor = value
@export var max_armor:int
@export var bite_range: Area2D
@export var bite_hitbox: Area2D
@export var healthbar: ProgressBar
@export var armorbar: ProgressBar
@export var egg_scene : PackedScene
@export var clay_scene : PackedScene
@export var rock_node_proj : PackedScene
@export var lower_body_armor: Sprite2D
@export var upper_body_armor: Sprite2D
@export var right_arm_armor: Sprite2D
@export var left_arm_armor: Sprite2D
@export var head_armor: Sprite2D

var bite_cooldown_timer:float
const BITE_COOLDOWN:float = 2
enum State {
	CHASING,
	START_BITING,
	BITING,
	START_DIGGING,
	DIGGING,
	RESTING,
	DYING
}
var c_state : State = State.CHASING

func _ready() -> void:
	super()
	bite_range.body_entered.connect(
		func(body):
			if body is Player and bite_cooldown_timer <= 0 and c_state == State.CHASING:
				c_state = State.START_BITING
	)
	armor = max_armor
	armorbar.max_value = max_armor
	healthbar.max_value = max_health
var attack_timer:float = 0.0
func _physics_process(delta: float) -> void:
	super(delta)
	healthbar.value = health
	armorbar.value = armor
	lower_body_armor.visible = armor > max_armor * 0.8
	left_arm_armor.visible = armor > max_armor * 0.6
	right_arm_armor.visible = armor > max_armor * 0.5
	upper_body_armor.visible = armor > max_armor * 0.3
	head_armor.visible = armor > 0
	var plr : Player = Main.instance.get_player()
	if bite_cooldown_timer > 0:
		bite_cooldown_timer -= delta
	match c_state:
		State.CHASING:
			enemy_sprite.sprite.scale.x = -1 if position.x <= plr.position.x else 1
			attack_timer += delta
			enemy_sprite.animate("walk")
			basic_movement(delta)
			if attack_timer > 5:
				attack_timer = 0
				c_state = State.START_DIGGING
			if bite_range.get_overlapping_bodies().has(plr) and bite_cooldown_timer <= 0:
				c_state = State.START_BITING
		State.START_BITING:
			start_bite()
			c_state = State.BITING
			velocity = Vector2.ZERO
		State.START_DIGGING:
			dig_sequence()
		State.RESTING:
			attack_timer += delta
			if attack_timer >= 5:
				attack_timer = 0
				enemy_sprite.force_animate("post_dig")
				await enemy_sprite.hit
				var amount_added = roundi(max_armor * 0.11)
				armor += amount_added
				Global.popup_text(str("+",amount_added),position - Vector2(0,64),Color.WEB_GRAY)
				await enemy_sprite.animation_player.animation_finished
				attack_timer = 0
				c_state = State.CHASING
	move_and_collide(velocity * delta)

var plr_in_bite_range: bool = false


func dig_sequence():
	velocity = Vector2.ZERO
	c_state = State.DIGGING
	var flr = Main.instance.current_floor
	var tile_arr: Array[Vector2i]
	for i in 4:
		tile_arr.append(flr.current_layout.get_random_free_tile())
	enemy_sprite.force_animate("pre_dig")
	await enemy_sprite.animation_player.animation_finished
	enemy_sprite.animate("dig")
	for tile in tile_arr:
		await enemy_sprite.hit
		var rock:RockNode = egg_scene.instantiate() if randf_range(0,1) < 0.3 else clay_scene.instantiate()
		if rock is LuepusEgg:
			rock.TIME_TO_SPAWN = 8
		grid.set_point_solid(tile)
		rock.position = tilemap.map_to_local(tile) + rock.rock_placement_offset
		var proj:RockNodeProjectile = Projectile.new_projectile(rock_node_proj, position, Vector2.ZERO)
		proj.rock_node = rock
		#flr.rock_nodes.add_child(rock)
	await enemy_sprite.animation_player.animation_finished
	enemy_sprite.animate("rest_idle")
	c_state = State.RESTING

func start_bite():
	var plr : Player = Main.instance.get_player()
	enemy_sprite.force_animate("bite")
	bite_hitbox.rotation = deg_to_rad(90) + plr.position.direction_to(position).angle()

	var temp_vel:Vector2 = position.direction_to(plr.position) * (12 * movement_speed)
	await enemy_sprite.hit
	velocity = temp_vel
	await enemy_sprite.hit
	velocity = Vector2.ZERO
	plr_in_bite_range = bite_hitbox.get_overlapping_bodies().has(plr)
	if plr_in_bite_range:
		var bite_dmg = 10 if head_armor.visible else 6
		plr.hurt(ElementalType.ET_Neutral.new(bite_dmg,plr), position)
	await enemy_sprite.animation_player.animation_finished
	bite_cooldown_timer = BITE_COOLDOWN
	c_state = State.CHASING

func on_mine(strength:int):
	Global.popup_text(str(strength*3),position - Vector2(0,64),Color.WEB_GRAY)
	armor -= strength * 3

func is_mineable(target_tile:Vector2i):
	if super(target_tile):
		if target_tile.distance_to(get_current_tile()) <= 2:
			return true
	return false

func hurt(elm:ElementalType,source:Variant=null):
	elm.damage = max(1, roundi(elm.damage * float(float((max_armor) - armor * 0.8) / (max_armor))))
	var armor_dmg:int = max(1, elm.damage * 0.05)
	armor -= armor_dmg
	Global.popup_text(str(armor_dmg),position - Vector2(0,64),Color.WEB_GRAY)
	super(elm,source)
