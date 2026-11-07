class_name DynamiteWeak
extends Item

func _init(stk:int=1) -> void:
	anim_type = AnimationType.NONE
	max_stack = 20
	super(stk)

func add_recipes():
	var recipe = Recipe.new()
	recipe.add_ingredient(Clay, 3)
	recipe.add_ingredient(Sulfur, 2)
	recipe.add_ingredient(IronOre, 4)
	recipe.set_result(DynamiteWeak.new(2))
	recipe.register()
