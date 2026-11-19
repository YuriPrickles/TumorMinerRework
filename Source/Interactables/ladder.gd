class_name Ladder
extends Interactable

func _process(delta: float) -> void:
	set_outline(hovered)

func interact(plr:Player):
	super(plr)
	Global.run_info.depth += 1
	Main.instance.refresh_floor()
