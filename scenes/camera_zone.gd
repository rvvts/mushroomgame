extends Area3D

@export var offset := Vector3(0, 5, 10)
@export var secondary_offset := Vector3(0, 5, 10)

func _ready():
	add_to_group("camera_zones")
