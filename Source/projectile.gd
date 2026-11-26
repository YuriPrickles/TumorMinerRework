class_name Projectile
extends Area2D
@export var collision_shape: CollisionShape2D

@export var hostile: bool
@export var damage: int
@export var knockback: float

var velocity: Vector2
var lifetime: float = 3

static func new_projectile(proj:PackedScene, pos, vel, dmg, h=false) -> Projectile:
	var projectile:Projectile = proj.instantiate()
	projectile.position = pos
	projectile.velocity = vel
	projectile.damage = dmg
	projectile.hostile = h
	assert(projectile is Projectile,"not a projectile!")
	Main.instance.current_floor.projectiles.add_child(projectile)
	return projectile
func _ready() -> void:
	body_entered.connect(
		on_body_enter
	)

func _process(delta: float) -> void:
	tick_down(delta)
	movement()

func movement():
	position += velocity #Main.instance.get_player().position

func tick_down(delta:float):
	lifetime -= delta
	if lifetime <= 0:
		destroy()

func destroy():
	on_destroy()
	queue_free()
	
func on_destroy():
	pass

func on_body_enter(body:Node2D):
	if body is Player:
		on_collide_player(body as Player)
	if body is Enemy:
		on_collide_enemy(body as Enemy)
	if body is TileMapLayer:
		on_collide_wall()
	if body is RockNode:
		on_collide_rock(body as RockNode)
	

func on_collide_player(plr:Player):
	pass
func on_collide_enemy(enemy:Enemy):
	pass
func on_collide_wall():
	pass
func on_collide_rock(rock:RockNode):
	pass
