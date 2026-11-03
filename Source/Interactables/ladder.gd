class_name Ladder
extends Interactable

func interact(plr:Player):
	super(plr)
	Main.instance.refresh_floor()
