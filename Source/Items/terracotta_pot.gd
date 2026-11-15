class_name TerracottaPot
extends Item

func _init(stk:int=1) -> void:
	anim_type = AnimationType.NONE
	max_stack = 40
	super(stk)

func add_recipes():
	var recipe:Recipe = Recipe.new()
	recipe.add_ingredient(ClayPotMold,1)
	recipe.set_result(TerracottaPot.new())
	recipe.register_smelt(3.5)
