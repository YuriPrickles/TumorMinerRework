extends Control

@export var grid_container: GridContainer
var inv: Array[Item]

func _ready() -> void:
	inv = Global.inv_manager.inventory


func _process(delta: float) -> void:
	for i in (inv.size()):
		var item_slot:ItemSlot = grid_container.get_child(i)
		item_slot.selected = Global.current_item_index == i
		if inv[i]:
			item_slot.stack_number.text = "[right]%s" % inv[i].stack if inv[i].stack > 1 else ""
			item_slot.texture = inv[i].texture
		else:
			item_slot.stack_number.text = ""
			item_slot.texture = null
