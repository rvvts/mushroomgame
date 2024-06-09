#===============================================================================
# Unhide DebugMaxDistance to see the sphere that is used for this.
# Basically:
# - targetpos is the center of the sphere. it only moves enough to keep the
#   player inside. it moves at a certain speed
# - offsetpos is targetpos + an offset (probably set via camera zones)
# - the camera moves towards offsetpos at a certain speed, and always looks
#   toward targetpos
#===============================================================================
extends Camera3D

@export var target: Node3D = null
@export var speed := 20.0
@export var offset := Vector3(0, 5, 10)
@export var max_distance := 4.0

var targetpos := Vector3.ZERO

func _ready():
	EventBus.camera_move.connect(_on_camera_move)

func _on_camera_move(offset: Vector3):
	self.offset = offset

func _physics_process(delta: float):
	if not is_instance_valid(target): return
	
	# if targetpos is too far away from target, move it closer
	if targetpos.distance_to(target.global_position) > max_distance:
		var difference := target.global_position - targetpos
		var direction := difference.normalized()
		var step := direction * speed * delta
		if step.length() + max_distance < difference.length():
			targetpos += direction * speed * delta
		else: # check for overshoot, prevents jittering
			targetpos = target.global_position - direction * max_distance
			pass
	
	var offsetpos := targetpos + offset
	
	# move camera towards offsetpos
	var difference := offsetpos - global_position
	var cameratooffsetspeed := speed * 0.3 # lower speed means camera will turn more while chasing offsetpoint
	var step := difference * cameratooffsetspeed * delta
	if step.length_squared() < difference.length_squared():
		global_position += step
	else:
		global_position = offsetpos
	
	look_at(targetpos)
	
	$DebugMaxDistance.global_position = targetpos
	$DebugMaxDistance.radius = max_distance

func _on_camera_zone_detector_area_entered(area: Area3D):
	if area.is_in_group("camera_zones"):
		offset = area.offset
