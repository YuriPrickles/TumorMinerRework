class_name RunInfo
extends Resource

var depth: int = 1
var health: int = 100
var build: Build = Build.new()

class Build:
	var capacity: int = 16
	var parts: Array[Part]
	
	func gain_part(part:Part) -> void:
		parts.append(part)
	
	func get_current_capacity() -> int:
		var total = 0
		for part in parts:
			total += part.points
		return total
	func can_fit_capacity(points:int) -> bool:
		var total = 0
		for part in parts:
			total += part.points
		return total + points <= capacity
