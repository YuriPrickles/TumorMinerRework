class_name ElementalType
extends Resource

@export var damage:int = 0
@export var color:Color = Color(1.0, 1.0, 1.0, 1.0)
var status_damage:bool
var target_plr:Player
var target_enm:Enemy
func _init(amount:int,target:Variant,is_status:bool=false) -> void:
	damage = amount
	status_damage = is_status
	if target is Player:
		target_plr = target
		target_plr.react_to_element(self,status_damage)
	if target is Enemy:
		target_enm = target
		target_enm.react_to_element(self,status_damage)
class ET_Neutral extends ElementalType:
	pass
class ET_Fire extends ElementalType:
	func _init(amount:int,target:Variant,is_status:bool=false) -> void:
		super(amount,target,is_status)
		color = Color(1.0, 0.426, 0.3, 1.0)

class ET_Sulfur extends ElementalType:
	func _init(amount:int,target:Variant,is_status:bool=false) -> void:
		super(amount,target,is_status)
		color = Color(0.812, 0.682, 0.0, 1.0)

class ET_Poison extends ElementalType:
	func _init(amount:int,target:Variant,is_status:bool=false) -> void:
		super(amount,target,is_status)
		color = Color(0.0, 0.695, 0.249, 1.0)

class ET_Water extends ElementalType:
	func _init(amount:int,target:Variant,is_status:bool=false) -> void:
		super(amount,target,is_status)
		color = Color(0.331, 0.642, 1.0, 1.0)
