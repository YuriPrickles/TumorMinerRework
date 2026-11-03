class_name Item
extends Resource

static var items:Array[Script]
static func register_item(script:Script):
	if items.has(script): return
	items.append(script)

enum Type {
	ITEM,
	PICKAXE,
	WEAPON,
	PART,
	PLACEABLE
}

enum AnimationType {
	NONE,
	INVISIBLE,
	PICKAXE,
	EAT,
	RAISE
}

@export var name : String:
	get:
		return Main.main_lang.get_dialog("ITEM_%s" % get_item_class_name().to_upper())
@export var description : String:
	get:
		return Main.main_lang.get_dialog("ITEM_DESC_%s" % get_item_class_name().to_upper())
@export var max_stack : int = 1
@export var texture : Texture2D
@export var type : Type
@export var anim_type: AnimationType = AnimationType.NONE
@export var use_delay: float = 1
@export var consumable: bool = false

@export var damage: int = 0

var stack: int = 1:
	set(value):
		if value > max_stack:
			stack = max_stack
			return
		stack = value

func _init(stk:int = 1) -> void:
	texture = load("%s/%s.png" % [
		Global.items_texture_path,
		get_item_class_name().to_snake_case()
		])
	stack = stk

func on_switch_to(plr:Player):
	pass

func on_switch_away(plr:Player):
	pass

func use_item(plr:Player) -> bool:
	plr.held_item.do_animation(self)
	if consumable: on_consume(plr)
	return true

func on_consume(plr:Player):
	await plr.held_item.animation_hit
	stack -= 1
	Global.inv_manager.validate_item_slot(self)

func can_use_item() -> bool:
	if anim_type == AnimationType.NONE:
		return false
	return true

func get_item_class_name() -> String:
	return(get_script() as Script).get_global_name()

func add_recipes():
	pass
