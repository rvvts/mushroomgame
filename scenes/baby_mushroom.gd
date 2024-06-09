extends CharacterBody3D

var parent_mushroom: Node3D = null # set to player once they enter range

var speed := 6.0
var acceleration := 500.0
var deceleration := 500.0
var jump_speed := 10.0
var gravity := 100.0

func _ready():
	add_to_group("child")

func do_movement(delta: float):
	if not is_instance_valid(parent_mushroom): return
	
	var movement := parent_mushroom.global_position - global_position
	movement.y = 0
	movement = movement.normalized()
	
	if movement.length_squared() < 0.1:
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
	
	if is_on_floor():
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

func _physics_process(delta):
	do_movement(delta)
	
	if Input.is_action_just_pressed("move_left"):
		$AnimatedSprite3D.flip_h = false
	if Input.is_action_just_pressed("move_right"):
		$AnimatedSprite3D.flip_h = true
	
	# teleport to parent if too far
	if is_instance_valid(parent_mushroom):
		if global_position.distance_to(parent_mushroom.global_position) > 100:
			global_position = parent_mushroom.global_position + Vector3.UP * 5
			velocity = Vector3.ZERO
	
