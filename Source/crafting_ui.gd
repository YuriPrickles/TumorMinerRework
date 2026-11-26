class_name CraftingUI
extends Control

@export var grid_container: GridContainer
@export var ingredients_container: GridContainer
@export var crafting_recipe_button: PackedScene
@export var item_name: RichTextLabel
@export var item_texture: TextureRect
@export var item_description: RichTextLabel
@export var craft_button: Button
@export var glossary_button: Button

var loaded_recipes:Array[Recipe]
var target_recipe:Recipe = null

var displaying_glossary:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	craft_button.pressed.connect(craft)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open_crafting():
	reload()
	show()
	get_tree().paused = true

func close_crafting():
	hide()
	get_tree().paused = false

func reload():
	if target_recipe and not target_recipe.check_craftable():
		target_recipe = null
		item_name.text = ""
		item_texture.texture = null
		item_description.text = ""
	loaded_recipes.clear()
	for child in grid_container.get_children():
		child.queue_free()
	for child in ingredients_container.get_children():
		child.queue_free()
	for recipe in Recipe.recipes:
		if displaying_glossary or recipe.check_craftable():
			loaded_recipes.append(recipe)
	
	for recipe in loaded_recipes:
		var button:CraftingRecipeButton = crafting_recipe_button.instantiate()
		button.texture_normal = recipe.result_item.texture
		button.pressed.connect(update_results.bind(recipe))
		button.stack_number.text = "[right]%s" % recipe.result_item.stack
		if !recipe.check_craftable():
			button.modulate.v = 0.5
		grid_container.add_child(button)
	
	
	if displaying_glossary:
		glossary_button.text = "View Craftable Only"
	else:
		glossary_button.text = "View Recipe Glossary"

func update_results(recipe:Recipe):
	target_recipe = recipe
	item_name.text = "[center]%s" % recipe.result_item.name
	item_texture.texture = recipe.result_item.texture
	item_description.text = "[center]%s" % recipe.result_item.description
	craft_button.visible = recipe.check_craftable()
	
	for child in ingredients_container.get_children():
		child.queue_free()
	
	for ingredient in recipe.ingredient_list:
		var button:CraftingRecipeButton = crafting_recipe_button.instantiate()
		button.texture_normal = ingredient.new().texture
		button.stack_number.text = "[right]%s" % recipe.ingredient_list[ingredient]
		ingredients_container.add_child(button)

func craft():
	if not target_recipe: return
	if target_recipe.craft_item():
		reload()


func _on_glossary_button_pressed() -> void:
	displaying_glossary = !displaying_glossary
	reload()
