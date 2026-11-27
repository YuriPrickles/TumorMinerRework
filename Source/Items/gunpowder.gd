class_name Gunpowder
extends Item

func _init(stk:int=1) -> void:
	anim_type = AnimationType.NONE
	max_stack = 40
	super(stk)

func add_recipes():
	var recipe:Recipe = Recipe.new()
	recipe.add_ingredient(Sulfur,1)
	recipe.add_ingredient(Charcoal,3)
	recipe.set_result(Gunpowder.new(2))
	recipe.register()
