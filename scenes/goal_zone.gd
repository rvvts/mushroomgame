extends Area3D

@export var min_babies := 3

func _physics_process(delta: float) -> void:
	var babies := 0
	var has_parent := false
	for b in get_overlapping_bodies():
		if b.is_in_group("children"):
			babies += 1
		if b.is_in_group("parents"):
			has_parent = true
	
	if has_parent and babies >= min_babies:
		win()

func win():
	print("ice cream :3")
	get_tree().quit()
