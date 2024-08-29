## General purpose resource that represents a level in the game.
## Contains the scene path and other metadata about the level.
class_name LevelResource
extends Resource

## The scene to load when the player enters this level.
@export var scene_path: String

## The name of the level.
@export var name: String

## The description of the level.
@export var description: String

# So on and so forth...