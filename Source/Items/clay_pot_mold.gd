class_name ClayPotMold
extends Item

func _init(stk:int=1) -> void:
	anim_type = AnimationType.NONE
	max_stack = 40
	super(stk)

func add_recipes():
	var recipe:Recipe = Recipe.new()
	recipe.add_ingredient(Clay,2)
	recipe.set_result(ClayPotMold.new())
	recipe.register()
