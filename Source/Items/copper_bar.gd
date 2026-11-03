class_name CopperBar
extends Item

func _init(stk:int=1) -> void:
	anim_type = AnimationType.NONE
	max_stack = 20
	super(stk)

func add_recipes():
	var recipe = Recipe.new()
	recipe.add_ingredient(CopperOre,3)
	recipe.set_result(CopperBar.new())
	recipe.register_smelt()
