class_name LuepusEgg
extends RockNode

const TIME_TO_SPAWN:float = 4.0
var spawn_timer:float=0.0
func drop_loot():
	pass
	#Pickup.new_pickup(IronOre.new(randi_range(2,4)),position)
var luepling : PackedScene = load("res://Source/Enemies/luepling.tscn")
func _process(delta: float) -> void:
	super(delta)
	spawn_timer += delta
	if spawn_timer > TIME_TO_SPAWN:
		break_rock()
		var enemy:Luepling = luepling.instantiate()
		Main.instance.current_floor.enemies.add_child(enemy)
		enemy.position = position
