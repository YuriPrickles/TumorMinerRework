extends Control

var displayed_part:Part
var connected_part_container:PartContainer
@export var part_name: RichTextLabel
@export var description: RichTextLabel
@export var item_texture: TextureRect
@export var remove_button: Button
@export var part_container_list: VBoxContainer
@export var capacity_bar: ProgressBar

@export var part_container_scene: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	remove_button.pressed.connect(remove_button_pressed)
	hide()

func display_part_containers():
	var parts = Global.run_info.build.parts
	for child in part_container_list.get_children():
		child.queue_free()
	for part in parts:
		var container:PartContainer = part_container_scene.instantiate()
		container.attached_part = part
		container.set_part(part)
		container.button.pressed.connect(part_selected.bind(container))
		part_container_list.add_child(container)
	capacity_bar.value = Global.run_info.build.get_current_capacity()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open_menu():
	show()
	display_part_containers()

func close_menu():
	hide()

func part_selected(part:PartContainer):
	print("yo")
	connected_part_container = part
	displayed_part = part.attached_part
	part_name.text=part.attached_part.name
	description.text = part.attached_part.description
	item_texture.texture = part.attached_part.texture

func remove_button_pressed():
	if not (displayed_part and connected_part_container): return
	Global.run_info.build.parts.erase(displayed_part)
	connected_part_container.queue_free()
	displayed_part.reset_effect(Main.instance.get_player())
	displayed_part = null
	part_name.text= ""
	description.text = ""
	item_texture.texture = null
