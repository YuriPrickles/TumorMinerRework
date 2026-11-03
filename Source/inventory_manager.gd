class_name InventoryManager
extends Resource

@export var inventory:Array[Item]

func _init() -> void:
	inventory.resize(9)
	inventory[0] = Pickaxe.new()
	inventory[1] = Bonesaber.new()
	inventory[2] = MiniSmelter.new(4)
	inventory[3] = CopperOre.new(18)
	inventory[4] = BatLeg.new()

func validate_item_slot(item:Item) -> void:
	if item.stack <= 0 and inventory.has(item):
		inventory[inventory.find(item)] = null

func get_item_count(item:Script) -> int:
	var filtered_inv:Array[Item] = inventory.filter(
		func(i:Item):
			if not i: return false
			return i.get_item_class_name() == item.get_global_name()
	)
	var total: int = 0
	for i in filtered_inv:
		total += i.stack
	return total

func drop_item(index) -> void:
	inventory[index] = null

func consume_item(item:Script, amount) -> void:
	for i in range(inventory.size()):
		if amount <= 0: break
		if not inventory[i]: continue
		if inventory[i].get_item_class_name() == item.get_global_name():
			var stack_left: int = amount - inventory[i].stack
			if stack_left < 0:
				inventory[i].stack = absi(stack_left)
			if stack_left == 0:
				amount = 0
				inventory[i] = null
			if stack_left > 0:
				amount = stack_left
				inventory[i] = null

func attempt_acquire(pickup:Pickup,item:Item):
	for i in range(inventory.size()):
		if inventory[i] and item.get_item_class_name() == inventory[i].get_item_class_name() and inventory[i].stack != inventory[i].max_stack:
			if inventory[i].stack + item.stack <= inventory[i].max_stack:
				inventory[i].stack += item.stack
				pickup.queue_free()
				break
			else:
				pickup.item_stored.stack = inventory[i].stack + item.stack - inventory[i].max_stack
				inventory[i].stack = inventory[i].max_stack
				attempt_acquire(pickup,pickup.item_stored)
				break
		elif not inventory[i]:
			if get_item_count(item.get_script()) > 0: continue
			inventory[i] = item
			if item.stack > item.max_stack:
				inventory[i].stack = inventory[i].max_stack
				item.stack -= inventory[i].stack
				continue
			pickup.queue_free()
			break

func check_can_acquire(item:Item) -> bool:
	for i in range(inventory.size()):
		if not inventory[i]:
			if item.stack > item.max_stack:
				continue
			return true
		elif item.get_item_class_name() == inventory[i].get_item_class_name() and inventory[i].stack != inventory[i].max_stack:
			if inventory[i].stack + item.stack <= inventory[i].max_stack:
				return true
			else:
				return true
	return false
