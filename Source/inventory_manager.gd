class_name InventoryManager
extends Resource

@export var inventory:Array[Item]
const INVROW_SIZE = 9
var max_invrows:int = 2
var current_row:int = 0
func get_invrow_offset():
	return current_row * INVROW_SIZE
func _init() -> void:
	inventory.resize(18)
	inventory[0] = Pickaxe.new()
	inventory[1] = Bonesaber.new()
	#inventory[0] = IronPickaxe.new()
	#inventory[1] = RubyWand.new()
	#inventory[2] = EmeraldWand.new()
	#inventory[3] = Spear.new()
	#inventory[4] = BoilerBlaster.new()
	#inventory[5] = Sulfurang.new()
	#inventory[6] = SulfurDustSprayer.new()

func validate_item_slot(item:Item) -> void:
	if item.stack <= 0 and inventory.has(item):
		inventory[inventory.find(item)] = null

func find_stackable(item:Script) -> Item:
	var filtered_inv:Array[Item] = inventory.filter(
		func(i:Item):
			if not i: return false
			return i.get_item_class_name() == item.get_global_name()
	)
	for thing in filtered_inv:
		if thing.stack < thing.max_stack:
			return thing
	return null

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
	var priority_start:int = Global.inv_manager.get_invrow_offset()
	for i in range(inventory.size()):
		i = (priority_start + i) % inventory.size()
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
	var priority_start:int = Global.inv_manager.get_invrow_offset()
	for i in range(inventory.size()):
		i = (priority_start + i) % inventory.size()
		if inventory[i] and item.get_item_class_name() == inventory[i].get_item_class_name() and inventory[i].stack < inventory[i].max_stack:
			if inventory[i].stack + item.stack <= inventory[i].max_stack:
				inventory[i].stack += item.stack
				pickup.queue_free()
				break
			else:
				item.stack = inventory[i].stack + item.stack - inventory[i].max_stack
				inventory[i].stack = inventory[i].max_stack
				attempt_acquire(pickup,item)
				break
		elif not inventory[i]:
			var stackable_searched:Item = find_stackable(item.get_script())
			if stackable_searched:
				if stackable_searched.stack + item.stack <= stackable_searched.max_stack:
					stackable_searched.stack += item.stack
					pickup.queue_free()
				else:
					pickup.item_stored.stack = stackable_searched.stack + item.stack - stackable_searched.max_stack
					stackable_searched.stack = stackable_searched.max_stack
					attempt_acquire(pickup,pickup.item_stored)
					break
				break
			inventory[i] = item
			if item.stack > item.max_stack:
				inventory[i].stack = inventory[i].max_stack
				item.stack -= inventory[i].stack
				continue
			pickup.queue_free()
			break

func check_can_acquire(item:Item) -> bool:
	var priority_start:int = Global.inv_manager.get_invrow_offset()
	for i in range(inventory.size()):
		i = (priority_start + i) % inventory.size()
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
