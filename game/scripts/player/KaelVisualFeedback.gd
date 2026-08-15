class_name KaelVisualFeedback
extends Node

@export var body_path: NodePath = NodePath("../Body")

@export_category("Movement Feel")
@export var walk_bob_amount: float = 0.035
@export var run_bob_amount: float = 0.065
@export var bob_speed: float = 8.0
@export var lean_amount: float = 0.045
@export var smoothness: float = 10.0

var time: float = 0.0
var base_position: Vector3
var base_rotation: Vector3

@onready var body: Node3D = get_node_or_null(body_path)

func _ready() -> void:
        if body:
                base_position = body.position
                base_rotation = body.rotation

func update_visuals(delta: float, speed: float, grounded: bool) -> void:
        if not body:
                return

        var weight: float = 1.0 - exp(-smoothness * delta)

        if grounded and speed > 0.1:
                var intensity: float = (
                        run_bob_amount
                        if speed > 6.0
                        else walk_bob_amount
                )

                time += delta * bob_speed * (speed / 4.2)

                var bob_y: float = abs(sin(time)) * intensity
                var bob_x: float = sin(time * 0.5) * intensity * 0.45

                var target_position: Vector3 = base_position + Vector3(
                        bob_x,
                        bob_y,
                        0.0
                )

                body.position = body.position.lerp(
                        target_position,
                        weight
                )

                var target_lean: float = sin(time) * lean_amount

                body.rotation.z = lerp(
                        body.rotation.z,
                        base_rotation.z + target_lean,
                        weight
                )
        else:
                time = lerp(time, 0.0, weight)

                body.position = body.position.lerp(
                        base_position,
                        weight
                )

                body.rotation = body.rotation.lerp(
                        base_rotation,
                        weight
                )
