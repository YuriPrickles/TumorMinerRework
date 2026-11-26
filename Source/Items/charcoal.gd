class_name Charcoal
extends Item

func _init(stk:int=1) -> void:
	anim_type = AnimationType.NONE
	max_stack = 40
	super(stk)

func add_recipes():
	var recipe:Recipe = Recipe.new()
	recipe.add_ingredient(Wood,1)
	recipe.set_result(Charcoal.new())
	recipe.register_smelt(1.5)
