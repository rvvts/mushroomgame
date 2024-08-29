extends Node

signal player_died
signal camera_move(offset: Vector3) # when the camera direction changes; offset is the new camera offset from the player

signal teleport_player(to: Vector3)