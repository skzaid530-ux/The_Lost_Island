class_name Kael
extends CharacterBody3D

@export_category("Movement")
@export var walk_speed: float = 4.2
@export var run_speed: float = 7.2
@export var acceleration: float = 20.0
@export var deceleration: float = 24.0
@export var jump_velocity: float = 6.5
@export var rotation_speed: float = 10.0

@export_category("Camera")
@export var camera_distance: float = 5.5
@export var camera_height: float = 2.8

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera: Camera3D = $CameraPivot/Camera3D

func _ready() -> void:
	camera.current = true

func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_handle_jump()
	_handle_movement(delta)
	move_and_slide()

func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	elif velocity.y < 0.0:
		velocity.y = -0.5

func _handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

func _handle_movement(delta: float) -> void:
	var input_vector := Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_backward"
	)

	var camera_forward := -camera_pivot.global_transform.basis.z
	var camera_right := camera_pivot.global_transform.basis.x

	camera_forward.y = 0.0
	camera_right.y = 0.0

	camera_forward = camera_forward.normalized()
	camera_right = camera_right.normalized()

	var direction := (
		camera_right * input_vector.x +
		camera_forward * input_vector.y
	)

	if direction.length_squared() > 1.0:
		direction = direction.normalized()

	var running := Input.is_key_pressed(KEY_SHIFT)
	var target_speed := run_speed if running else walk_speed
	var target_velocity := direction * target_speed

	var horizontal_velocity := Vector3(velocity.x, 0.0, velocity.z)

	if direction != Vector3.ZERO:
		horizontal_velocity = horizontal_velocity.move_toward(
			target_velocity,
			acceleration * delta
		)

		var target_angle := atan2(-direction.x, -direction.z)

		rotation.y = lerp_angle(
			rotation.y,
			target_angle,
			rotation_speed * delta
		)
	else:
		horizontal_velocity = horizontal_velocity.move_toward(
			Vector3.ZERO,
			deceleration * delta
		)

	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z
