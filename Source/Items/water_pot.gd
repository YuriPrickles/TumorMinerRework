class_name WaterPot
extends Item

func _init(stk:int=1) -> void:
	anim_type = AnimationType.NONE
	max_stack = 20
	super(stk)

func add_recipes():
	var recipe:Recipe = Recipe.new()
	recipe.add_ingredient(TerracottaPot,1)
	recipe.add_needs_water(true)
	recipe.set_result(WaterPot.new())
	recipe.register()
