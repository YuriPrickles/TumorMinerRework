extends Node

@export var inv_manager:InventoryManager
var current_item_index:int
var run_info:RunInfo
var health_drain_timer:float = 0
var base_health_drain_delay:float = 2.4
var plr_active_effects:Array[StatusEffect]

@export_dir var items_texture_path: String

func _ready() -> void:
	start_new_run()

func get_current_item() -> Item:
	return inv_manager.inventory[current_item_index]

func _process(delta: float) -> void:
	health_drain_timer += delta
	if health_drain_timer >= base_health_drain_delay:
		health_drain_timer = 0
		run_info.health -= 1
func start_new_run():
	run_info = RunInfo.new()
	inv_manager = InventoryManager.new()

func save_plr_effects(status_array:Array[StatusEffect]) -> void:
	plr_active_effects = status_array
func load_plr_effects() -> Array[StatusEffect]:
	return plr_active_effects

@export var popup_text_scene:PackedScene

func popup_text(t:String,pos:Vector2,clr:Color=Color.WHITE) -> void:
	var pt_inst = (popup_text_scene.instantiate())
	pt_inst.text = str("[center][color=%s]" % clr.to_html(), t)
	pt_inst.position = pos
	var flr: Floor = Main.instance.current_floor
	flr.add_child(pt_inst)
