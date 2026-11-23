class_name ElementalType
extends Resource

@export var damage:int = 0
@export var color:Color = Color(1.0, 1.0, 1.0, 1.0)
var target_plr:Player
var target_enm:Enemy
func _init(amount:int,target:Variant) -> void:
	damage = amount
	if target is Player:
		target_plr = target
		target_plr.react_to_element(self)
	if target is Enemy:
		target_enm = target
		target_enm.react_to_element(self)
class ET_Neutral extends ElementalType:
	pass
class ET_Fire extends ElementalType:
	func _init(amount:int,target:Variant) -> void:
		super(amount,target)
		color = Color(1.0, 0.426, 0.3, 1.0)

class ET_Sulfur extends ElementalType:
	func _init(amount:int,target:Variant) -> void:
		super(amount,target)
		color = Color(0.812, 0.682, 0.0, 1.0)

class ET_Poison extends ElementalType:
	func _init(amount:int,target:Variant) -> void:
		super(amount,target)
		color = Color(0.0, 0.695, 0.249, 1.0)
