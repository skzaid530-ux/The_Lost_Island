class_name ThirdPersonCamera
extends Node3D

@export var target: Node3D
@export var distance: float = 5.5
@export var height: float = 2.8
@export var mouse_sensitivity: float = 0.012
@export var follow_smoothness: float = 10.0
@export var min_pitch: float = -35.0
@export var max_pitch: float = 55.0

var yaw: float = 0.0
var pitch: float = -8.0

@onready var camera: Camera3D = $Camera3D

func _ready() -> void:
	camera.current = true

func _process(delta: float) -> void:
	if not is_instance_valid(target):
		return

	global_position = global_position.lerp(
		target.global_position + Vector3.UP * height,
		1.0 - exp(-follow_smoothness * delta)
	)

	rotation.x = pitch
	rotation.y = yaw

	camera.position = Vector3(0.0, 0.0, distance)

func rotate_camera(horizontal: float, vertical: float) -> void:
	yaw -= horizontal * mouse_sensitivity
	pitch -= vertical * mouse_sensitivity
	pitch = clamp(pitch, deg_to_rad(min_pitch), deg_to_rad(max_pitch))
