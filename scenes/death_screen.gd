extends CanvasLayer

func _on_retry_pressed():
	get_tree().change_scene_to_file("res://scenes/gameplay_screen.tscn")
