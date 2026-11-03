class_name RockSpawn
extends Resource

@export var rock_weights: Array[RockWeight]

@export_range(0.0,1.0) var rock_spawn_chance: float

func get_weights() ->  Array[float]:
	var array: Array[float]
	for rw in rock_weights:
		array.append(rw.weight)
	return array


func get_rocks() -> Array[PackedScene]:
	var array: Array[PackedScene]
	for rw in rock_weights:
		array.append(rw.rock_type)
	return array
