extends Node

@export var inv_manager:InventoryManager
var current_item_index:int
var run_info:RunInfo
var health_drain_timer:float = 0
var base_health_drain_delay:float = 2.4

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
