class_name Main
extends Node

static var instance:Main
var current_floor: Floor
@export var floor_scene: PackedScene
@export var fader: Fader
@export var crafting_ui: CraftingUI
@export var parts_menu_ui: Control



static var main_lang:Language
func _init() -> void:
	instance = self
	main_lang = Language.from_txt("res://Dialog/English.txt")
	#region Load All Recipes
	for cl:Dictionary in ProjectSettings.get_global_class_list():
		if Item.subclasses.has(cl.base):
			var scr := load(cl.path)
			Item.register_item(scr)
	for item in Item.items:
		var temp_item:Item = item.new()
		temp_item.add_recipes()
	#endregion
func _ready() -> void:
	refresh_floor()
func get_player() -> Player:
	return current_floor.get_node("Player")
func refresh_floor():
	fader.fade_in()
	await fader.faded_in
	if current_floor: current_floor.queue_free()
	current_floor = floor_scene.instantiate()
	add_child(current_floor)
	fader.fade_out()
	await fader.faded_out

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("crafting") and not fader.animation_player.is_playing():
		if not crafting_ui.visible:
			crafting_ui.open_crafting()
		else:
			crafting_ui.close_crafting()
	if event.is_action_pressed("parts_menu") and not fader.animation_player.is_playing():
		if not parts_menu_ui.visible:
			parts_menu_ui.open_menu()
		else:
			parts_menu_ui.close_menu()
