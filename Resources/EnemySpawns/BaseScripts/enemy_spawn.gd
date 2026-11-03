class_name EnemySpawn
extends Resource

@export var enemy_weights: Array[EnemyWeight]

@export_range(0.0,1.0) var enemy_spawn_chance: float

func get_weights() ->  Array[float]:
	var array: Array[float]
	for w in enemy_weights:
		array.append(w.weight)
	return array


func get_enemies() -> Array[PackedScene]:
	var array: Array[PackedScene]
	for w in enemy_weights:
		array.append(w.enemy_type)
	return array
