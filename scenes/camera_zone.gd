#===============================================================================
# The camera angle changes depending on which camera zone the player is in.
# Zones can have multiple angles (2 for now) that the player can cycle between.
# An Area3D on the player does the detecting - these zones are passive.
# monitoring = false
# monitorable = true
# collision layer = 32 (camera_zone)
# collision mask = none
#===============================================================================
extends Area3D

@export var offset := Vector3(0, 5, 10)
@export var secondary_offset := Vector3(0, 5, 10)

func _ready():
	add_to_group("camera_zones")
