class_name IronPickaxe
extends Pickaxe

func _init(stk:int=1) -> void:
	super(stk)
	strength = 2
	use_delay = 0.25

func add_recipes():
	var recipe = Recipe.new()
	recipe.add_ingredient(IronBar,5)
	recipe.set_result(IronPickaxe.new())
	recipe.register()
