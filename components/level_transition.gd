class_name LevelTransition
extends Area3D

## Level resources contain the packed scene and other metadata.
@export var go_to_level: LevelResource

## The player will be placed in front of the `area_target` when they are sent to the new scene.
## The name should be the same as the node in the target scene.
@export var area_target: String
