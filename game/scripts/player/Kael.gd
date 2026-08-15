class_name Kael
extends CharacterBody3D

@export_category("Movement")
@export var walk_speed: float = 4.0
@export var run_speed: float = 7.0
@export var acceleration: float = 18.0
@export var deceleration: float = 22.0
@export var jump_velocity: float = 6.5

@export_category("Camera")
@export var camera_distance: float = 5.0
@export var camera_height: float = 2.8

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var camera_pivot: Node3D

func _ready() -> void:
	camera_pivot = get_node_or_null("CameraPivot")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	var input_vector := Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_backward"
	)

	var direction := Vector3(input_vector.x, 0.0, input_vector.y)

	if direction.length() > 1.0:
		direction = direction.normalized()

	var target_speed := run_speed if Input.is_key_pressed(KEY_SHIFT) else walk_speed
	var target_velocity := direction * target_speed

	if direction != Vector3.ZERO:
		velocity.x = move_toward(velocity.x, target_velocity.x, acceleration * delta)
		velocity.z = move_toward(velocity.z, target_velocity.z, acceleration * delta)

		var target_rotation := atan2(-direction.x, -direction.z)
		rotation.y = lerp_angle(rotation.y, target_rotation, 10.0 * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, deceleration * delta)
		velocity.z = move_toward(velocity.z, 0.0, deceleration * delta)

	move_and_slide()
