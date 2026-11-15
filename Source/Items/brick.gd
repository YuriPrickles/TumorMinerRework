class_name Brick
extends Item

func _init(stk:int=1) -> void:
	anim_type = AnimationType.NONE
	max_stack = 40
	super(stk)

func add_recipes():
	var recipe:Recipe = Recipe.new()
	recipe.add_ingredient(Clay,1)
	recipe.set_result(Brick.new())
	recipe.register_smelt(2.5)
