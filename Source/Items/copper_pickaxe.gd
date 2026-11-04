class_name CopperPickaxe
extends Pickaxe

func _init(stk:int=1) -> void:
	super(stk)
	strength = 1
	use_delay = 0.1

func add_recipes():
	var recipe = Recipe.new()
	recipe.add_ingredient(CopperBar,5)
	recipe.set_result(CopperPickaxe.new())
	recipe.register()
