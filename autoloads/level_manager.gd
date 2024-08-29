extends Node

func change_to(level: LevelResource, transition_name: String) -> void:
    var level_scene : PackedScene = load(level.scene_path)
    var new_level : Node = level_scene.instantiate()
    var new_transition : LevelTransition = new_level.find_child(transition_name)
    
    if is_instance_valid(new_transition):
        var level_container = get_tree().root.get_node("GameplayScreen").get_children()
        for child in level_container:
            if child != new_level:
                child.queue_free()

        get_tree().root.get_node("GameplayScreen").add_child(new_level)
        EventBus.emit_signal("teleport_player", new_transition.spawn_marker.global_position)
        print(new_transition.spawn_marker.global_position)
    else:
        print("Transition not found in new level scene.")
