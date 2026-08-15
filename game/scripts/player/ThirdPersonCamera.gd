class_name ThirdPersonCamera
extends Node3D

@export_category("Follow")
@export var target: Node3D
@export var distance: float = 5.5
@export var height: float = 2.8
@export var follow_smoothness: float = 10.0

@export_category("Orbit")
@export var mouse_sensitivity: float = 0.012
@export var min_pitch: float = -35.0
@export var max_pitch: float = 55.0
@export var orbit_smoothness: float = 12.0

@export_category("Camera Feel")
@export var movement_fov: float = 70.0
@export var sprint_fov: float = 76.0
@export var fov_smoothness: float = 5.0

var yaw: float = 0.0
var pitch: float = -8.0
var target_yaw: float = 0.0
var target_pitch: float = -8.0

@onready var camera: Camera3D = $Camera3D

func _ready() -> void:
        camera.current = true
        camera.fov = movement_fov

func _process(delta: float) -> void:
        if not is_instance_valid(target):
                return

        var follow_weight := 1.0 - exp(-follow_smoothness * delta)

        global_position = global_position.lerp(
                target.global_position + Vector3.UP * height,
                follow_weight
        )

        var orbit_weight := 1.0 - exp(-orbit_smoothness * delta)

        yaw = lerp_angle(yaw, target_yaw, orbit_weight)
        pitch = lerp(pitch, target_pitch, orbit_weight)

        rotation.x = pitch
        rotation.y = yaw

        camera.position = Vector3(0.0, 0.0, distance)

        var target_fov := movement_fov

        if target is CharacterBody3D:
                var horizontal_speed := Vector2(
                        target.velocity.x,
                        target.velocity.z
                ).length()

                if horizontal_speed > 6.0:
                        target_fov = sprint_fov

        camera.fov = lerp(
                camera.fov,
                target_fov,
                1.0 - exp(-fov_smoothness * delta)
        )

func rotate_camera(horizontal: float, vertical: float) -> void:
        target_yaw -= horizontal * mouse_sensitivity
        target_pitch -= vertical * mouse_sensitivity
        target_pitch = clamp(
                target_pitch,
                deg_to_rad(min_pitch),
                deg_to_rad(max_pitch)
        )
