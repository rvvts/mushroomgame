class_name LevelTransition
extends Area3D

@export var level_resource: LevelResource

## Where the player will spawn when they enter this level.
@export var spawn_marker: Marker3D

func _ready():
    body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
    if body is Mommy:
        if is_instance_valid(level_resource):
            LevelManager.change_to(level_resource, self.name)