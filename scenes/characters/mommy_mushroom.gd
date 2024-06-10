#===============================================================================
# This is the player.
# It ignores collisions with baby mushrooms (though they do not ignore
# collisions with the player), so you can push baby mushrooms out of the way.
# collision layer: 9 (parent)
# collision mask: 1 (terrain)
#
# CameraZoneDetector detects which camera zone we're in. Its settings are:
# monitoring = true
# monitorable = false
# collision layer = none
# collision mask = 32 (camera_zone)
#===============================================================================
extends CharacterBody3D

var speed := 10.0
var acceleration := 500.0
var deceleration := 500.0
var jump_speed := 20.0
var gravity := 100.0

var horizontal_camera_angle := 0.0
var new_horizontal_camera_angle := 0.0 # don't change actual angle until movement keys are released
var is_secondary_angle := false # whether or not to use a camera zone's secondary_offset instead of offset

@onready var camera_zone_detector: Area3D = $CameraZoneDetector

func _ready():
	add_to_group("parents")
	EventBus.camera_move.connect(_on_camera_move)

func _on_camera_move(offset: Vector3):
	offset.y = 0
	new_horizontal_camera_angle = offset.signed_angle_to(Vector3.BACK, Vector3.DOWN)

func do_movement(delta: float):
	var movement := Vector3.ZERO
	movement.x = Input.get_axis("move_left", "move_right")
	movement.z = Input.get_axis("move_up", "move_down")
	movement = movement.rotated(Vector3.UP, horizontal_camera_angle)
	
	if movement.length_squared() < 0.1:
		horizontal_camera_angle = new_horizontal_camera_angle
		
		var newspeed := velocity.length() - deceleration * delta
		if newspeed > 0:
			velocity = limit_horizontal_length(velocity, newspeed)
		else:
			velocity.x = 0
			velocity.z = 0
	
	else:
		movement = movement.normalized()
		velocity += movement * acceleration * delta
		velocity = limit_horizontal_length(velocity, speed)
	
	# gravity
	if not is_on_floor():
		velocity.y -= 100 * delta
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_speed
	
	move_and_slide()

func limit_horizontal_length(v: Vector3, l: float) -> Vector3:
	var v2 := Vector2(v.x, v.z)
	v2 = v2.limit_length(l)
	v.x = v2.x
	v.z = v2.y
	return v

func die():
	queue_free()
	EventBus.player_died.emit()
	get_tree().change_scene_to_file("res://scenes/death_screen.tscn")

func _physics_process(delta):
	do_movement(delta)
	
	if Input.is_action_just_pressed("move_left"):
		$AnimatedSprite3D.flip_h = false
	if Input.is_action_just_pressed("move_right"):
		$AnimatedSprite3D.flip_h = true
	
	# die if fell too low
	if position.y < -100:
		die()
	
	# update camera angle when we enter a new camera zone
	for z in camera_zone_detector.get_overlapping_areas():
		if z.is_in_group("camera_zones"):
			if is_secondary_angle:
				EventBus.camera_move.emit(z.secondary_offset)
			else:
				EventBus.camera_move.emit(z.offset)
			break
	
	if Input.is_action_just_pressed("cycle_camera"):
		is_secondary_angle = not is_secondary_angle
	
	if Input.is_action_just_pressed("command_children_wait"):
		for c in $CommandZone.get_overlapping_bodies():
			if c.is_in_group("children"):
				c.should_wait = true
	if Input.is_action_just_pressed("command_children_come"):
		for c in $CommandZone.get_overlapping_bodies():
			if c.is_in_group("children"):
				c.should_wait = false

func _on_child_detector_body_entered(body):
	if body.is_in_group("children"):
		body.parent_mushroom = self
