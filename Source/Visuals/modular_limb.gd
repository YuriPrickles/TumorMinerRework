class_name ModularLimb
extends Node2D

#Internal Meta
## Referenced Limb Resource for visuals
@export var source_limb:Item

#Positional Information
## Marker Node where the limb originates (Shoulder, Hip)
@export var Origin:Node2D

#Visual Displays
## Line2D Node for displaying the limb
@export var LimbDisplay:Line2D
## Node for displaying Apex (Hand, Foot)
@export var ApexDisplay:Node

#Fun Spring Physics
@export var spring_rigidity:float = 0.1
@export var spring_damping:float = 0.2
@export var apex_velocity:Vector2 = Vector2.ZERO
@export var apex_destination:Vector2 = Vector2.ZERO

func _process(delta):
	global_position = Origin.global_position
	
	#Spring Physics
	var distance_to_destination = ApexDisplay.position - apex_destination
	var loss = spring_damping * apex_velocity
	var force = -spring_rigidity * distance_to_destination - loss
	apex_velocity += force
	ApexDisplay.position += force
	
	LimbDisplay.set_point_position(1, -(global_position - ApexDisplay.global_position) )
	
	#Set Visuals
	if source_limb:
		#Set Limb Color
		if "limb_color" in source_limb:
			LimbDisplay.default_color = source_limb.limb_color
		
		#Set Apex Texture
		if "apex_texture" in source_limb and "texture" in ApexDisplay:
			ApexDisplay.texture = source_limb.apex_texture

func get_local_destination(global_destination:Vector2):
	return global_destination - ApexDisplay.global_position
