class_name Projectile
extends Area2D
@export var collision_shape: CollisionShape2D

@export var hostile: bool
@export var damage: int
@export var knockback: float = 500

var velocity: Vector2
var lifetime: float = 3

var hit_enemies_array : Array[Enemy]
var hit_players_array : Array[Player]

static func new_projectile(proj:PackedScene, pos, vel, dmg=-1, h=null) -> Projectile:
	var projectile:Projectile = proj.instantiate()
	projectile.position = pos
	projectile.velocity = vel
	projectile.damage = dmg if dmg >= 0 else projectile.damage
	projectile.hostile = h if h else projectile.hostile
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
	

func on_collide_player(plr:Player) -> bool:
	if not hostile: return false
	if not hit_players_array.has(plr):
		hit_players_array.append(plr)
		plr.hurt(damage,position,knockback)
	else:
		return false
	return true
func on_collide_enemy(enemy:Enemy) -> bool:
	if hostile: return false
	if not hit_enemies_array.has(enemy):
		hit_enemies_array.append(enemy)
		enemy.hurt(damage,self)
	else:
		return false
	return true
func on_collide_wall():
	pass
func on_collide_rock(rock:RockNode):
	pass
