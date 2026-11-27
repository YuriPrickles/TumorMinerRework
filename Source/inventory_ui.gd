extends Control

@export var grid_containers: Array[GridContainer]
var inv: Array[Item]

func _ready() -> void:
	inv = Global.inv_manager.inventory


func _process(delta: float) -> void:
	for i in (inv.size()):
		var item_slot:ItemSlot = grid_containers[((9 - (i % 9) + i) - 1) / 9].get_child(i % 9)
		item_slot.selected = Global.current_item_index == (i)
		if inv[i]:
			item_slot.stack_number.text = "[right]%s" % inv[i].stack if inv[i].stack > 1 else ""
			item_slot.texture = inv[i].texture
		else:
			item_slot.stack_number.text = ""
			item_slot.texture = null
	for i in grid_containers.size():
		if i == Global.inv_manager.current_row:
			grid_containers[i].show()
		else:
			grid_containers[i].hide()
